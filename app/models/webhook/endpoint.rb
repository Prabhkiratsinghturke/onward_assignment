module Webhook
  class Endpoint < ApplicationRecord
    
    # Associations
    has_many :event_requests, class_name: "Webhook::EventRequest", foreign_key: :webhook_endpoint_id, dependent: :destroy
    has_many :headers, class_name: "Webhook::Header", foreign_key: :webhook_endpoint_id, inverse_of: :webhook_endpoint, dependent: :destroy

    # Validations
    validates :url, presence: true, format: URI.regexp(%w(http https))
    validates :events, presence: true

    # Enums
    enum :status, { active: 'active', disable: 'disable'}

    # Callbacks
    after_update :update_event_requests_url, :update_event_requests_status

    accepts_nested_attributes_for :headers, reject_if: :all_blank, allow_destroy: true


    def self.for_event(events)
      where('events @> ARRAY[?]::varchar[]', Array(events))
    end

    def subscribed?(event)
      events.include? event
    end

    def events=(events)
      events = Array(events).map { |event| event.to_s }
      super(Webhook::Event::EVENT_TYPES & events)
    end

    def disable!
      update!(status: 'disable')
    end

    private

    def update_event_requests_url
      return unless saved_change_to_url?

      event_requests.active.update_all(url: url)
    end

    def update_event_requests_status
      event_requests.disable_not_for_events!(events)
    end
  end
end