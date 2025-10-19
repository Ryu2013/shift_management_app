class CreateUserClients < ActiveRecord::Migration[7.2]
  def change
    create_table :user_clients do |t|
      t.references :office, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :client, foreign_key: true, null: false
      t.string :note

      t.timestamps
    end
  end
end
