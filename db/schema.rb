# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181117184850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "automated_responses", force: :cascade do |t|
    t.string "name_of_response"
    t.string "subject"
    t.text "response"
    t.integer "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trigger"
    t.boolean "is_active", default: false
  end

  create_table "response_presets", force: :cascade do |t|
    t.string "name"
    t.integer "vendor_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "vendor_dispute_messages", force: :cascade do |t|
    t.integer "vendor_dispute_id"
    t.text "body"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
  end

  create_table "vendor_disputes", force: :cascade do |t|
    t.integer "vendor_id"
    t.string "first_name"
    t.string "last_name"
    t.string "order_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "subject"
  end

  create_table "vendor_pages", force: :cascade do |t|
    t.bigint "shopify_page_id"
    t.string "shopify_page_handle"
    t.string "shopify_page_title"
    t.integer "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vendors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store"
    t.string "name"
    t.index ["email"], name: "index_vendors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_vendors_on_reset_password_token", unique: true
  end

end
