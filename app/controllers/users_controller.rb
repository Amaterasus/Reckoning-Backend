class UsersController < ApplicationController

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age}
        else
            render json: { message: "login error"}
        end
    end


end
