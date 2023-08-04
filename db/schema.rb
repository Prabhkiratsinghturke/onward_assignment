# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_04_063611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.integer "quantity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webhook_custom_headers", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.bigint "webhook_endpoint_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_endpoint_id"], name: "index_webhook_custom_headers_on_webhook_endpoint_id"
  end

  create_table "webhook_endpoints", force: :cascade do |t|
    t.string "url", null: false
    t.string "status", default: "active"
    t.string "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "events", default: [], array: true
  end

  create_table "webhook_event_requests", force: :cascade do |t|
    t.bigint "webhook_endpoint_id", null: false
    t.jsonb "payload", default: {}
    t.jsonb "response", default: {}
    t.string "event"
    t.string "status"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_endpoint_id"], name: "index_webhook_event_requests_on_webhook_endpoint_id"
  end

  create_table "webhook_headers", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.bigint "webhook_endpoint_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_endpoint_id"], name: "index_webhook_headers_on_webhook_endpoint_id"
  end

  add_foreign_key "webhook_custom_headers", "webhook_endpoints"
  add_foreign_key "webhook_event_requests", "webhook_endpoints"
  add_foreign_key "webhook_headers", "webhook_endpoints"
end
