class Expert < ApplicationRecord
  has_many :headlines
  
  validates :name, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))

  after_save :shorten_url, if: :saved_change_to_url
  after_save :scrape_page
  
  private  
  def shorten_url
    # Ideally I'd like to not do 2 sql updates/inserts but time is of the essence
    bitly = Bitly.client.shorten(url)
    update_attributes(short_url: bitly.short_url)
  end
end
