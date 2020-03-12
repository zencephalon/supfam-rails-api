class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :current_status, :avatar_url
end
