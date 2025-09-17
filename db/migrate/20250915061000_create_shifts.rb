class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.references :office, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.date :date
      t.integer :kind
      t.integer :slots
      t.string :note

      t.timestamps
    end
  end
end
