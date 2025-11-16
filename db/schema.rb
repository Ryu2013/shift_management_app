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

ActiveRecord::Schema[7.2].define(version: 2025_11_16_034424) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_needs", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "client_id", null: false
    t.integer "week", null: false
    t.integer "shift_type", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.integer "slots", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_needs_on_client_id"
    t.index ["office_id"], name: "index_client_needs_on_office_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "team_id", null: false
    t.integer "medical_care"
    t.string "name", null: false
    t.string "email"
    t.string "address"
    t.string "disease"
    t.string "public_token"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_clients_on_office_id"
    t.index ["team_id"], name: "index_clients_on_team_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_offices_on_name", unique: true
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "client_id", null: false
    t.integer "shift_type"
    t.string "note"
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "is_escort", default: false
    t.integer "work_status", default: 0
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.index ["client_id"], name: "index_shifts_on_client_id"
    t.index ["office_id"], name: "index_shifts_on_office_id"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_teams_on_office_id"
  end

  create_table "user_clients", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "user_id", null: false
    t.bigint "client_id", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "user_id"], name: "index_user_clients_on_client_id_and_user_id", unique: true
    t.index ["client_id"], name: "index_user_clients_on_client_id"
    t.index ["office_id"], name: "index_user_clients_on_office_id"
    t.index ["user_id"], name: "index_user_clients_on_user_id"
  end

  create_table "user_needs", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.bigint "user_id", null: false
    t.integer "week"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_user_needs_on_office_id"
    t.index ["user_id"], name: "index_user_needs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "name", null: false
    t.string "address"
    t.integer "pref_per_week"
    t.string "commute"
    t.integer "account_status", default: 0, null: false
    t.string "note"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "role", default: 0, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "second_factor_attempts_count"
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "otp_secret"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["office_id"], name: "index_users_on_office_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "client_needs", "clients"
  add_foreign_key "client_needs", "offices"
  add_foreign_key "clients", "offices"
  add_foreign_key "clients", "teams"
  add_foreign_key "shifts", "clients"
  add_foreign_key "shifts", "offices"
  add_foreign_key "shifts", "users"
  add_foreign_key "teams", "offices"
  add_foreign_key "user_clients", "clients"
  add_foreign_key "user_clients", "offices"
  add_foreign_key "user_clients", "users"
  add_foreign_key "user_needs", "offices"
  add_foreign_key "user_needs", "users"
  add_foreign_key "users", "offices"
  add_foreign_key "users", "teams"
end
