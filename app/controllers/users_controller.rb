class UsersController < ApplicationController
    include RestClient

    def show
        user = User.find_by(id: params[:id])
        games_url = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{key}&include_appinfo=true&steamid="

        res = RestClient.get("#{games_url}#{user.steamID64}")

        render json: {user: user, games: JSON.parse(res.body)}
    end

    def key
        ENV["STEAM_KEY"]
    end

    def get_games

        user = User.find_by(id: params[:id])
        
        games_url = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{key}&include_appinfo=true&steamid="

        res = RestClient.get("#{games_url}#{user.steamID64}")
        render json: JSON.parse(res.body)
        # byebug


    end

    def register
        user = User.create(createUserParams)

        if user.valid?
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, avatar_url: user.steam_avatar_url, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            render json: {  id: user.id, username: user.username, bio: user.bio, age: user.age, avatar_url: user.steam_avatar_url, steamID64: user.steamID64, token: generate_token({id: user.id}) }
        else
            render json: { message: "login error"}
        end
    end

    def validate
        user = get_user
        
        if user
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, avatar_url: user.steam_avatar_url, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end


    private

    def createUserParams
        params.require(:user).permit(:username, :email, :dob, :steamID64, :password, :password_confirmation, :steam_avatar_url)
    end

    def passwordParams
        params.permit(:password, :password_confirmation)
    end
end
