class ApplyMermaidSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :office, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
    add_index :teams, [:office_id, :name], unique: true

    execute <<~SQL.squish
      UPDATE offices
      SET slug = id::text
      WHERE slug IS NULL OR slug = '';
    SQL
    change_column_null :offices, :slug, false


    change_table :clients do |t|
      t.references :team, foreign_key: true
      t.integer :medical_care
      t.string :disease
      t.string :public_token, null: false
    end
    add_index :clients, :public_token, unique: true

    create_table :client_needs do |t|
      t.references :office, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.integer :week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :slots, null: false, default: 1
      t.timestamps
    end

    create_table :employee_clients do |t|
      t.references :office, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.text :note
      t.timestamps
    end
    add_index :employee_clients, [:office_id, :employee_id, :client_id], unique: true, name: 'idx_employee_clients_uniqueness'

    change_column_null :employees, :office_id, false

    change_table :employees do |t|
      t.references :team, foreign_key: true
      t.string :address
      t.string :commute
      t.string :pref_days
      t.integer :pref_per_week
      t.text :note
      t.string :role
      t.integer :account_status, null: false, default: 0
      t.string :invitation_token
      t.datetime :invitation_created_at
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.bigint :invited_by_id
      t.string :invited_by_type
      t.integer :invitations_count, default: 0, null: false
    end
    add_index :employees, :invitation_token, unique: true
    add_index :employees, [:invited_by_type, :invited_by_id]

    remove_index :employees, :email
    add_index :employees, [:office_id, :email], unique: true

    create_table :employee_needs do |t|
      t.references :office, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.integer :week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.timestamps
    end

    change_column_default :shifts, :slots, from: nil, to: 1
    execute <<~SQL.squish
      UPDATE shifts SET slots = 1 WHERE slots IS NULL
    SQL
    change_column_null :shifts, :slots, false

    add_index :shift_members, [:office_id, :shift_id, :employee_id], unique: true

    create_table :mail_logs do |t|
      t.references :office, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.string :subject
      t.datetime :sent_at
      t.string :api_status
      t.text :api_error
      t.string :gmail_message_id
      t.timestamps
    end

    create_table :mail_recipients do |t|
      t.references :office, null: false, foreign_key: true
      t.references :mail_log, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.integer :delivery_status
      t.text :error_message
      t.timestamps
    end
    add_index :mail_recipients, [:mail_log_id, :employee_id]

    create_table :contact_statuses do |t|
      t.references :office, null: false, foreign_key: true
      t.references :shift_member, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.boolean :is_notified, null: false, default: false
      t.datetime :notified_at
      t.timestamps
    end
    add_index :contact_statuses, [:shift_member_id, :employee_id]
  end
end
