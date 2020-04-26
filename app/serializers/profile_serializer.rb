# typed: strict
class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :status, :seen, :avatar_url, :updated_at, :name, :is_default, :phone
end
