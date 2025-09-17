class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.references :office, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :address
      t.text :note

      t.timestamps
    end
  end
end
