module Webhook
  module Observable
    extend ActiveSupport::Concern

    included do
      after_commit on: :create do
        send_deliver_req :created
      end

      after_commit on: :update do
        send_deliver_req :updated
      end

      after_commit on: :destroy do
        send_deliver_req :destroyed
      end
    end

    def send_deliver_req(action)
      DeliverRequestService.call(event: format_event_name(action), payload: self.as_json)
    end

    def format_event_name(action)
      self.class.name.underscore + '.' + action.to_s
    end
  end
end