class CreateUserTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :user_teams do |t|
      t.references :team, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
