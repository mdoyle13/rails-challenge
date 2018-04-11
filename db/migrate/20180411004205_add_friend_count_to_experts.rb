class AddFriendCountToExperts < ActiveRecord::Migration[5.2]
  def change
    add_column :experts, :friend_count, :integer
  end
end
