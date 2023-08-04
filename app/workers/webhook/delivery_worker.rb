require 'http.rb'

module Webhook
  class DeliveryWorker
    include Sidekiq::Worker

    sidekiq_options retry: 3, dead: false

    sidekiq_retry_in { 30.seconds }

    # sidekiq_retry_in do |retry_count|
    #   # Exponential backoff, with a random 30-second to 10-minute "jitter"
    #   # added in to help spread out any webhook "bursts."
    #   jitter = rand(30.seconds..10.minutes).to_i

    #   (retry_count ** 5) + jitter
    # end

    def perform(event_req_id)
      return unless @event_req = EventRequest.find_by_id(event_req_id)
      return if @event_req.disable?

      @endpoint = @event_req.webhook_endpoint
      unless @endpoint.subscribed?(@event_req.event)
        @endpoint.event_requests.disable_for_events!(@event_req.event)
        .disable_for_events!(events)
        return
      end

      send_request!

      if @response.status.success?
        @event_req.success!
        @event_req.update(response: success_response)

        return
      end

      request_failed(failed_response, )

      case @response.code
      when 410
        @endpoint.disable!
      when 400..599
        # perform any dependent operation here
      end
    rescue ::OpenSSL::SSL::SSLError # TLS issues may be due to an expired cert
      request_failed 'TLS_ERROR'
    rescue ::HTTP::ConnectionError
      request_failed 'CONNECTION_ERROR'
    rescue ::HTTP::TimeoutError
      request_failed 'TIMEOUT_ERROR'
    end

    private

    def send_request!
      req_body =  { event: @event_req.event, payload: @event_req.payload, }.to_json
      @response = HTTP.timeout(30)
                      .headers( format_req_headers)
                      .post(@endpoint.url, body: req_body )
    end

    def format_req_headers
      headers = {'User-Agent' => 'onward-assignment/1.0','Content-Type' => 'application/json'}
      @endpoint.headers.each do |header|
        headers["#{header.key}"] = header.value
      end
      headers
    end

    def request_failed(error)
      @event_req.failed!
      @event_req.update(response: { error: error })
      logger(error)
    end

    def logger error_code
      Sidekiq.logger.warn "[webhook_worker] Error for webhook event: type=#{@event_req.event} event=#{@event_req.id} endpoint=#{@endpoint.id} url=#{@endpoint.url} code=#{error_code}"
    end


    def success_response
      { headers: @response.headers.to_h,
        code: @response.code.to_i,
        body: @response.body.to_s,
      }
    end

    def failed_response
      { headers: @response.headers.to_h,
        code: @response.code.to_i,
      }
    end
  end
end