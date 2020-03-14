class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar_url

  def current_status
    object.current_status.first
  end
end
