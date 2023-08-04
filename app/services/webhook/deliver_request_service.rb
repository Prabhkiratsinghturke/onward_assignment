module Webhook
  class DeliverRequestService
    def self.call(event:, payload:)
      new(event: event, payload: payload).call
    end

    def call
      Endpoint.for_event(@event).active.find_each do |endpoint|
        event_request = create_event_request(endpoint)
        DeliveryWorker.perform_async(event_request.id)
      end
    end

    def create_event_request(endpoint)
      endpoint.event_requests.create!(webhook_request_params(endpoint.url))
    end

    private

    attr_accessor :event, :payload

    def initialize(event:, payload:)
      @event   = event
      @payload = payload
    end

    def webhook_request_params(url)
      {
        url: url,
        event: @event,
        payload: @payload,
        status: 'inprogress'
      }
    end
  end
end