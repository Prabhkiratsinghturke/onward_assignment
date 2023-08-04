module Webhook
  class Event
    EVENT_TYPES = %w(
      product.created
      product.updated
      product.destroyed
    ).freeze
  end
end