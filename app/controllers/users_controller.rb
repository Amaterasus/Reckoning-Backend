class UsersController < ApplicationController

    def show
        user = User.find_by(id: params[:id])
        # games = get_user.compare_with(user)
        if user == get_user
            render json: {user: user, games: user.games }
        else
            render json: {user: user, message: "Games failed to fetch" }
        end
    end

    def register
        user = User.create(createUserParams)

        if user.valid?
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, games: user.games, avatar_url: user.steam_avatar_url, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, games: user.games, avatar_url: user.steam_avatar_url, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end

    def validate
        user = get_user
        
        if user
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, avatar_url: user.steam_avatar_url, games: user.games, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end

    def avatar
        avatar = User.new(steamID64: params[:user][:steamID64]).getAvatar["avatarfull"]

        render json: {steam_avatar_url: avatar}
    end

    def search
        currentUser = get_user

        users = User.where("lower(username) like ?", "%#{params[:username].downcase}%")

        sendUsers = users.filter { |user| user.id != currentUser.id }

        render json: sendUsers
    end


    private

    def createUserParams
        params.require(:user).permit(:username, :email, :dob, :steamID64, :password, :password_confirmation, :steam_avatar_url)
    end

    def passwordParams
        params.permit(:password, :password_confirmation)
    end
end
