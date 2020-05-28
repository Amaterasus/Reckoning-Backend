class CreateSteamGames < ActiveRecord::Migration[6.0]
  def change
    create_table :steam_games do |t|
      t.string :name
      t.integer :appid

      t.timestamps
    end
  end
end
