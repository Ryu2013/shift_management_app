class CreateClientNeeds < ActiveRecord::Migration[7.2]
  def change
    create_table :client_needs do |t|
      t.references :office, foreign_key: true, null: false
      t.references :client, foreign_key: true, null: false
      t.integer :week
      t.integer :type
      t.time :start_time
      t.time :end_time
      t.integer :slots

      t.timestamps
    end
  end
end
