class Expert < ApplicationRecord
  has_many :headlines, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships, dependent: :destroy
  
  # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  # has_many :inverse_friends, :through => :inverse_friendships, :source => :expert
  
  validates :name, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))
  
  after_create :scrape_page
  after_save :shorten_url, if: :saved_change_to_url
  
  
  private  
  def shorten_url
    # Ideally I'd like to not do 2 sql updates/inserts but time is of the essence
    bitly = Bitly.client.shorten(url)
    update_attributes(short_url: bitly.short_url)
  end
  
  # Ideally I'd do this in a background Job
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
