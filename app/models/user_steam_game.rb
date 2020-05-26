class UserSteamGame < ApplicationRecord
    belongs_to :user
    belongs_to :steam_game
end
