class User < ApplicationRecord
    has_secure_password

    has_many :user_steam_games
    has_many :steam_games, through: :user_steam_games

    validates :steamID64, length: { is: 17 }
    validates :username, uniqueness: true
    

    def age
        now = Time.now.utc.to_date
        now.year - self.dob.year - ((now.month > self.dob.month || (now.month == self.dob.month && now.day >= self.dob.day)) ? 0 : 1)
    end

    def birthday
        bday = Date.new(Date.today.year, self.dob.month, self.dob.day)
        bday += 1.year if Date.today >= bday
        (bday - Date.today).to_i == 0
    end

    def key
        ENV["STEAM_KEY"]
    end

    def get_games
        games_url = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{key}&include_appinfo=true&steamid="

        res = RestClient.get("#{games_url}#{self.steamID64}")
        JSON.parse(res.body)["response"]["games"]
    end

    def cache_games
        self.get_games.each do |game|
            steam_game = SteamGame.find_by(appid: game["appid"])
            if !steam_game
                steam_game = SteamGame.create(appid: game["appid"], name: game["name"])
            end

            if !self.steam_games.include?(steam_game)
                UserSteamGame.create(steam_game_id: steam_game.id, user_id: self.id)
            end
        end
    end

    def compare_with(user)
        games_info = {
            shared: [],
            other: [],
        }
        
        my_game_ids = self.steam_games.map { |game| game["appid"] }
        user.steam_games.each do |game|
            if my_game_ids.include?(game["appid"])
                games_info[:shared] << game
            else
                games_info[:other] << game
            end
        end
        
        games_info
    end

    def group_finder(users)
        output = Hash.new()
        users_array = [self, users].flatten

        users_array.each do |user| 
            user.steam_games.each do |game| 
                if !output[game["appid"]] 
                    output[game["appid"]] = []
                end
                output[game["appid"]] << user.username
            end
        end

        output.sort_by { |key, value| value.length }.reverse.to_h
    end


    def get_avatar
        player_url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{key}&steamids="

        res = RestClient.get("#{player_url}#{steamID64}")
        JSON.parse(res.body)["response"]["players"][0]
    end
    
end
