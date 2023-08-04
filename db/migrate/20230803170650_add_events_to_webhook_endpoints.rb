class AddEventsToWebhookEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_column :webhook_endpoints, :events, :string, array: true, default: []
  end
end
