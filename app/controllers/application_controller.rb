class ApplicationController < ActionController::API

    def secret
        ENV["MY_SECRET"]
    end

    def generate_token(data)
        JWT.encode(data, secret)
    end

    def decode_token
        token = request.headers["Authorization"]
        begin
            JWT.decode(token, secret).first
        rescue
            {}
        end
    end

    def get_user
        id = decode_token["id"] 
        User.find_by(id: id)
    end

end
