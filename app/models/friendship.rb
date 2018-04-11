class Friendship < ApplicationRecord
  belongs_to :expert, counter_cache: :friend_count
  belongs_to :friend, class_name: "Expert"
end
