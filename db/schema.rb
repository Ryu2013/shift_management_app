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

ActiveRecord::Schema[7.0].define(version: 2025_09_15_070000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_needs", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "client_id", null: false
    t.integer "week", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.integer "slots", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_needs_on_client_id"
    t.index ["office_id"], name: "index_client_needs_on_office_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "name"
    t.string "email"
    t.string "address"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.integer "medical_care"
    t.string "disease"
    t.string "public_token", null: false
    t.index ["office_id"], name: "index_clients_on_office_id"
    t.index ["public_token"], name: "index_clients_on_public_token", unique: true
    t.index ["team_id"], name: "index_clients_on_team_id"
  end

  create_table "contact_statuses", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "shift_member_id", null: false
    t.bigint "employee_id", null: false
    t.boolean "is_notified", default: false, null: false
    t.datetime "notified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_contact_statuses_on_employee_id"
    t.index ["office_id"], name: "index_contact_statuses_on_office_id"
    t.index ["shift_member_id", "employee_id"], name: "index_contact_statuses_on_shift_member_id_and_employee_id"
    t.index ["shift_member_id"], name: "index_contact_statuses_on_shift_member_id"
  end

  create_table "employee_clients", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "employee_id", null: false
    t.bigint "client_id", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_employee_clients_on_client_id"
    t.index ["employee_id"], name: "index_employee_clients_on_employee_id"
    t.index ["office_id", "employee_id", "client_id"], name: "idx_employee_clients_uniqueness", unique: true
    t.index ["office_id"], name: "index_employee_clients_on_office_id"
  end

  create_table "employee_needs", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "employee_id", null: false
    t.integer "week", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_needs_on_employee_id"
    t.index ["office_id"], name: "index_employee_needs_on_office_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.bigint "office_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.string "address"
    t.string "commute"
    t.string "pref_days"
    t.integer "pref_per_week"
    t.text "note"
    t.string "role"
    t.integer "account_status", default: 0, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.integer "invitations_count", default: 0, null: false
    t.index ["invitation_token"], name: "index_employees_on_invitation_token", unique: true
    t.index ["invited_by_type", "invited_by_id"], name: "index_employees_on_invited_by_type_and_invited_by_id"
    t.index ["office_id", "email"], name: "index_employees_on_office_id_and_email", unique: true
    t.index ["office_id"], name: "index_employees_on_office_id"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_employees_on_team_id"
  end

  create_table "mail_logs", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "employee_id", null: false
    t.string "subject"
    t.datetime "sent_at"
    t.string "api_status"
    t.text "api_error"
    t.string "gmail_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_mail_logs_on_employee_id"
    t.index ["office_id"], name: "index_mail_logs_on_office_id"
  end

  create_table "mail_recipients", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "mail_log_id", null: false
    t.bigint "employee_id", null: false
    t.integer "delivery_status"
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_mail_recipients_on_employee_id"
    t.index ["mail_log_id", "employee_id"], name: "index_mail_recipients_on_mail_log_id_and_employee_id"
    t.index ["mail_log_id"], name: "index_mail_recipients_on_mail_log_id"
    t.index ["office_id"], name: "index_mail_recipients_on_office_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.string "slug", null: false
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
    t.index ["office_id", "shift_id", "employee_id"], name: "index_shift_members_on_office_id_and_shift_id_and_employee_id", unique: true
    t.index ["office_id"], name: "index_shift_members_on_office_id"
    t.index ["shift_id"], name: "index_shift_members_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "client_id", null: false
    t.date "date"
    t.integer "kind"
    t.integer "slots", default: 1, null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_shifts_on_client_id"
    t.index ["office_id"], name: "index_shifts_on_office_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id", "name"], name: "index_teams_on_office_id_and_name", unique: true
    t.index ["office_id"], name: "index_teams_on_office_id"
  end

  add_foreign_key "client_needs", "clients"
  add_foreign_key "client_needs", "offices"
  add_foreign_key "clients", "offices"
  add_foreign_key "clients", "teams"
  add_foreign_key "contact_statuses", "employees"
  add_foreign_key "contact_statuses", "offices"
  add_foreign_key "contact_statuses", "shift_members"
  add_foreign_key "employee_clients", "clients"
  add_foreign_key "employee_clients", "employees"
  add_foreign_key "employee_clients", "offices"
  add_foreign_key "employee_needs", "employees"
  add_foreign_key "employee_needs", "offices"
  add_foreign_key "employees", "teams"
  add_foreign_key "mail_logs", "employees"
  add_foreign_key "mail_logs", "offices"
  add_foreign_key "mail_recipients", "employees"
  add_foreign_key "mail_recipients", "mail_logs"
  add_foreign_key "mail_recipients", "offices"
  add_foreign_key "shift_members", "employees"
  add_foreign_key "shift_members", "offices"
  add_foreign_key "shift_members", "shifts"
  add_foreign_key "shifts", "clients"
  add_foreign_key "shifts", "offices"
  add_foreign_key "teams", "offices"
end
