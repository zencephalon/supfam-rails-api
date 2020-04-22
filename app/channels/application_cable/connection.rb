module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_profile

    def connect
      self.current_profile = authenticate
    end

    private 
      def authenticate
        authenticate_token || reject_unauthorized_connection
      end
    
      def authenticate_token
        token = request.params[:token]
        profileId = request.params[:profileId]
        return false unless token
        current_profile = User.find_by(api_key: token).profiles.find_by(id: request.params[:profileId])
        return current_profile
      end
  end
end
