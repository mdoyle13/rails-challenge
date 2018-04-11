class AddIndexToFriendships < ActiveRecord::Migration[5.2]
  def change
    add_index :friendships, :expert_id
  end
end
