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

ActiveRecord::Schema[7.0].define(version: 2024_08_16_165311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cpnj"
    t.string "name"
    t.string "trade_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "serial_number"
    t.string "invoice_number"
    t.string "integer"
    t.datetime "emission_date"
    t.uuid "issuing_company_id", null: false
    t.uuid "recipient_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issuing_company_id"], name: "index_invoices_on_issuing_company_id"
    t.index ["recipient_company_id"], name: "index_invoices_on_recipient_company_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.json "content", default: {}
    t.json "arguments", default: {}
    t.integer "progress", default: 0
    t.text "job_errors", default: [], array: true
    t.string "parentable_type"
    t.string "status", default: "pending"
    t.uuid "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_jobs_on_author_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "ncm"
    t.integer "cfop"
    t.string "unit_c"
    t.integer "quantity_c"
    t.float "unit_price"
    t.float "icms_price"
    t.float "ipi_price"
    t.float "pis_price"
    t.float "cofins_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "invoices", "companies", column: "issuing_company_id"
  add_foreign_key "invoices", "companies", column: "recipient_company_id"
  add_foreign_key "jobs", "users", column: "author_id"
end
