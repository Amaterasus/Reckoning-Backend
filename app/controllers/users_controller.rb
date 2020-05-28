class UsersController < ApplicationController

    def show
        user = User.find_by(id: params[:id])
        
        if user == get_user
            render json: {user: user, games: user.steam_games }
        else
            compared = get_user.compare_with(user)
            render json: {user: user, games: compared }
        end
    end

    def register
        user = User.create(create_user_params)

        if user.valid?
            user.cache_games
            render json: { id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, games: user.steam_games, avatar_url: user.steam_avatar_url, token: generate_token({id: user.id}) }
        else
            render json: { message: "login error"}
        end
    end

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            render json: { id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, games: user.steam_games, avatar_url: user.steam_avatar_url, token: generate_token({id: user.id}) }
        else
            render json: { message: "login error"}
        end
    end

    def validate
        user = get_user
        
        if user
            render json: { id: user.id, username: user.username, bio: user.bio, age: user.age, steamID64: user.steamID64, avatar_url: user.steam_avatar_url, games: user.steam_games, token: generate_token({id: user.id}) }
        else
            render json: { message: "login error"}
        end
    end

    def avatar
        avatar = User.new(steamID64: params[:user][:steamID64]).get_avatar["avatarfull"]

        render json: { steam_avatar_url: avatar }
    end

    def search
        currentUser = get_user

        users = User.where("lower(username) like ?", "%#{params[:username].downcase}%")

        send_users = users.filter { |user| user.id != currentUser.id }

        render json: send_users
    end

    def update_password
        user = get_user

        if user.update(password_params)
            render json: { message: "Success" }
        else
            render json: { message: "Failure" }
        end
    end

    def update_details
        user = get_user

        if user.update(details_params)
            render json: { bio: user.bio }
        else
            render json: { message: "Failure" }
        end
    end

    def find_group_games
        user = get_user

        group = User.where(id: params["_json"])

        render json: user.group_finder(group)
    end

    private

    def create_user_params
        params.require(:user).permit(:username, :email, :dob, :steamID64, :password, :password_confirmation, :steam_avatar_url)
    end

    def password_params
        params.permit(:password, :password_confirmation)
    end

    def details_params
        params.permit(:bio)
    end
end
