class CreateUserNeeds < ActiveRecord::Migration[7.2]
  def change
    create_table :user_needs do |t|
      t.references :office, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :week
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
