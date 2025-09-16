class CreateOffices < ActiveRecord::Migration[7.0]
  def change
    create_table :offices do |t|
      t.string :name
      t.string :registration_number
      t.string :slug

      t.timestamps
    end
    add_index :offices, :slug, unique: true
  end
end
