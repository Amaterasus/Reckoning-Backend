class CreateUserSteamGames < ActiveRecord::Migration[6.0]
  def change
    create_table :user_steam_games do |t|
      t.references :steam_game
      t.references :user

      t.timestamps
    end
  end
end
