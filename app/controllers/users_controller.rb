class UsersController < ApplicationController

    def index
        users = User.all

        render json: users
    end


    def signin
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            render json: { message: "success"}
        else
            render json: { message: "login error"}
        end
    end


end
