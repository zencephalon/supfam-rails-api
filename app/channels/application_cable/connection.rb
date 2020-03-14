module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = authenticate
    end

    private 
      def authenticate
        authenticate_token || reject_unauthorized_connection
      end
    
      def authenticate_token
        token = request.params[:token]
        return false unless token
        @current_user = User.find_by(api_key: token)
        return @current_user
      end
  end
end
