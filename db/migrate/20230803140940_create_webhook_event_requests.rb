class CreateWebhookEventRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_event_requests do |t|
      t.references :webhook_endpoint, null: false, foreign_key: true
      t.jsonb :payload, default: {}
      t.jsonb :response, default: {}
      t.string :event
      t.string :status
      t.string :url

      t.timestamps
    end
  end
end
