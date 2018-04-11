class Friendship < ApplicationRecord
  belongs_to :expert, counter_cache: :friend_count
  belongs_to :friend, class_name: "Expert"
  
  after_create :create_bi_directional, unless: :has_bi_directional?
  after_destroy :destroy_bi_directional, if: :has_bi_directional?
  
  private
  
  # inspired by this
  # https://collectiveidea.com/blog/archives/2015/07/30/bi-directional-and-self-referential-associations-in-rails
  def create_bi_directional
    self.class.create(bi_directional_attributes)
  end
  
  def has_bi_directional?
    self.class.exists?(bi_directional_attributes)
  end
  
  def destroy_bi_directional
    bi_directionals.destroy_all
  end
  
  def bi_directionals
    self.class.where(bi_directional_attributes)
  end
  
  def bi_directional_attributes
    { expert: friend, friend: expert }
  end
end
