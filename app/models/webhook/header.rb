module Webhook
  class Header < ApplicationRecord

    # Validations
    validates_presence_of :key, :value

    # Associations
    belongs_to :webhook_endpoint, class_name: "Webhook::Endpoint", foreign_key: :webhook_endpoint_id
  end
end