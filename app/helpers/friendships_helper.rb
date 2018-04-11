module FriendshipsHelper
  def mutual_friend_list(expert, friendships, other_expert)
    mututal_friend_ids = expert.mutual_friend_ids(other_expert.id)
    mututal_friendships = friendships.select { |f| mututal_friend_ids.include? f.friend_id }
    
    return nil unless mututal_friendships.present?
    content_tag :span do
      mututal_friendships.each_with_index do |f, idx|
        concat f.friend.name
        if mututal_friendships.length > 1 and (mututal_friendships.length - 1 != idx)
          concat ", "
        end
      end
    end
  end
end
