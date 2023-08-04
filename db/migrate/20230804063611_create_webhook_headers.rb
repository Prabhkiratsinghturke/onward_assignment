class CreateWebhookHeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_headers do |t|
      t.string :key
      t.string :value
      t.references :webhook_endpoint, null: false, foreign_key: true

      t.timestamps
    end
  end
end
