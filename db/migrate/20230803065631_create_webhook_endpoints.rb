class CreateWebhookEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_endpoints do |t|
      t.string :url, null: false
      t.string :status, default: 'active'
      t.string :event
      t.timestamps
    end
  end
end