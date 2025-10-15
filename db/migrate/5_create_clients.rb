class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.references :office, foreign_key: true, null: false
      t.references :team, foreign_key: true, null: false
      t.integer :medical_care
      t.string :name
      t.string :email
      t.string :address
      t.string :disease
      t.string :public_token
      t.string :note

      t.timestamps
    end
  end
end
