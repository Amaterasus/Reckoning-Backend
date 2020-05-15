class UsersController < ApplicationController
    
    def register
        user = User.create(createUserParams)
        user.update(passwordParams)

        if user.valid?
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end

    def validate
        user = get_user
        
        if user
            render json: {id: user.id, username: user.username, bio: user.bio, age: user.age, token: generate_token({id: user.id})}
        else
            render json: { message: "login error"}
        end
    end


    private

    def createUserParams
        params.require(:user).permit(:username, :email, :dob, :steamID64)
    end

    def passwordParams
        params.permit(:password, :password_confirmation)
    end
end
