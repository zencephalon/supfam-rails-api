class AddProfileIdToConversationMembership < ActiveRecord::Migration[6.0]
  def change
    add_reference :conversation_memberships, :profile, index: true
  end
end
