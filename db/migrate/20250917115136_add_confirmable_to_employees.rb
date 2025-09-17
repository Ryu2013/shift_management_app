class AddConfirmableToEmployees < ActiveRecord::Migration[7.0]
  def up
    add_column :employees, :confirmation_token, :string
    add_column :employees, :confirmed_at, :datetime
    add_column :employees, :confirmation_sent_at, :datetime
    add_column :employees, :unconfirmed_email, :string
    add_column :employees, :pending_office_name, :string

    add_index :employees, :confirmation_token, unique: true

    change_column_null :employees, :office_id, true

    execute <<~SQL.squish
      UPDATE employees
         SET confirmed_at = NOW(), confirmation_sent_at = NOW()
       WHERE confirmed_at IS NULL
    SQL
  end

  def down
    remove_index :employees, :confirmation_token

    remove_column :employees, :pending_office_name
    remove_column :employees, :unconfirmed_email
    remove_column :employees, :confirmation_sent_at
    remove_column :employees, :confirmed_at
    remove_column :employees, :confirmation_token

    change_column_null :employees, :office_id, false
  end
end
