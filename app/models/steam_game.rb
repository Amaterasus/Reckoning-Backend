class SteamGame < ApplicationRecord
    has_many :users
    has_many :users, through: :user_steam_games
end
