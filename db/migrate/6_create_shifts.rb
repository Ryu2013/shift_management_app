class CreateShifts < ActiveRecord::Migration[7.2]
  def change
    create_table :shifts do |t|
      t.references :office, foreign_key: true, null: false
      t.references :client, foreign_key: true, null: false
      t.integer :shift_type
      t.integer :slots, null: false, default: 1
      t.string :note
      t.date :date

      t.timestamps
    end
  end
end
