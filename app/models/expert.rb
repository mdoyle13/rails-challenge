class Expert < ApplicationRecord
  has_many :headlines, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships, dependent: :destroy
  
  validates :name, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))
  
  after_create :scrape_page
  after_save :shorten_url, if: :saved_change_to_url
  
  def self.get_friends_of_friends_ids(user_id)
    #friend_ids - friends_of_friends_ids - user in question
    friend_ids = self.get_experts_friend_ids(user_id)
    
    friends_of_friends_ids = []
    
    friend_ids.each do |id|
      friends_of_friends_ids << self.get_experts_friend_ids(id)
    end
    
    friends_of_friends_ids.flatten - friend_ids - [user_id]
  end
  
  def self.get_experts_friend_ids(expert_id)
    Friendship.where(expert_id: expert_id).pluck(:friend_id)
  end
  
  def not_self_and_not_already_friends(friend_ids)
    # where not the expert in question, dont want to include the expert themselves in the results
    results = Expert.where.not(id: self.id)
    # where there is not alread a friendship
    results = results.where.not(id: friend_ids)
    results
  end
  
  def mutual_friend_ids(other_expert_id)
    Expert.get_experts_friend_ids(self.id) && Expert.get_experts_friend_ids(other_expert_id)
  end
  
  def with_friends
    self.friendships.includes(:friend)
  end
  
  private
  
  def shorten_url
    bitly = Bitly.client.shorten(url)
    update_attributes(short_url: bitly.short_url)
  end
  
  # Ideally I'd do this in a background Job if time allowed
  def scrape_page
    scrape = ScraperService.new(url).call
    if scrape.success?
      attrs = scrape.data.map do |headline|
        {expert: self, text: headline}
      end
      Headline.create(attrs)
    end
  end
end
