class Headline < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_text_content, against: :text
  
  # move scrape here
  
  belongs_to :expert
end
