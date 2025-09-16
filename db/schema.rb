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

ActiveRecord::Schema[7.0].define(version: 2025_09_15_080726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "name"
    t.string "email"
    t.string "address"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_clients_on_office_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.bigint "office_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["office_id"], name: "index_employees_on_office_id"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "offices", force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_offices_on_slug", unique: true
  end

  create_table "shift_members", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "shift_id", null: false
    t.bigint "employee_id", null: false
    t.boolean "is_escort"
    t.integer "work_status"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_shift_members_on_employee_id"
    t.index ["office_id"], name: "index_shift_members_on_office_id"
    t.index ["shift_id"], name: "index_shift_members_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "client_id", null: false
    t.date "date"
    t.integer "kind"
    t.integer "slots"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_shifts_on_client_id"
    t.index ["office_id"], name: "index_shifts_on_office_id"
  end

  add_foreign_key "clients", "offices"
  add_foreign_key "shift_members", "employees"
  add_foreign_key "shift_members", "offices"
  add_foreign_key "shift_members", "shifts"
  add_foreign_key "shifts", "clients"
  add_foreign_key "shifts", "offices"
end
