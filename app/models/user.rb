class User < ApplicationRecord
    has_secure_password

    validates :steamID64, length: { is: 17 }

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

    def games
        games_url = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{key}&include_appinfo=true&steamid="

        res = RestClient.get("#{games_url}#{self.steamID64}")
        JSON.parse(res.body)["response"]["games"]
    end

    def getAvatar
        player_url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{key}&steamids="

        res = RestClient.get("#{player_url}#{steamID64}")
        JSON.parse(res.body)["response"]["players"][0]
    end
    
end
