class CreateWebhookCustomHeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_custom_headers do |t|
      t.string :key
      t.string :value
      t.references :webhook_endpoint, null: false, foreign_key: true

      t.timestamps
    end
  end
end
