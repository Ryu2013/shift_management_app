class CreateShiftMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :shift_members do |t|
      t.references :office, null: false, foreign_key: true
      t.references :shift, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.boolean :is_escort
      t.integer :work_status
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
