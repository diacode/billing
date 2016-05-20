# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160520114213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_records", force: :cascade do |t|
    t.string   "subject"
    t.decimal  "amount",         precision: 11, scale: 2
    t.decimal  "balance",        precision: 11, scale: 2
    t.date     "operation_at"
    t.date     "value_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.text     "billing_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "picture"
    t.string   "language",     default: "en"
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "code"
    t.date     "expiration"
    t.integer  "vat"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",        default: false
    t.integer  "customer_id"
    t.string   "currency"
  end

  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "description"
    t.date     "period_start"
    t.date     "period_end"
    t.decimal  "hours",         precision: 11, scale: 2
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "cost_cents",                             default: 0,     null: false
    t.string   "cost_currency",                          default: "EUR", null: false
  end

  add_index "items", ["invoice_id"], name: "index_items_on_invoice_id", using: :btree
  add_index "items", ["project_id"], name: "index_items_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "stack"
    t.datetime "start"
    t.datetime "ending"
    t.integer  "budget"
    t.integer  "ratio"
    t.integer  "hours_agreed"
    t.string   "tracking_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tracking_service"
    t.integer  "status"
    t.decimal  "hours_spent",      precision: 11, scale: 4, default: 0.0
  end

  add_index "projects", ["customer_id"], name: "index_projects_on_customer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
