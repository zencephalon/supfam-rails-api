class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :current_status, :current_seen, :avatar_url
end
