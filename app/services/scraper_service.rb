class ScraperService
  def initialize(url)
    @url = url
    @response = OpenStruct.new(success?: false, message: nil, data: [])
  end
  
  def call
    scrape
  end
  
  private
  
  def scrape
    page = Nokogiri::HTML(open(@url))
    headlines = extract_headlines(page)
    if headlines.present?
      @response.data = headlines
      @response.send("success?=", true)
      @response
    else
      return fail! message: "Failed to scrape the page #{@url}" 
    end
  end
  
  def extract_headlines(page)
    headlines = []
    page.search('h1', 'h2', 'h3').each do |headline|
      headlines << string_cleaner(headline.content)
    end
    headlines
  end
  
  def string_cleaner(str)
    str.downcase.gsub(/\W+/, ' ').squish
  end
  
  def fail!(message: )
    @response.message = message
    # if you don't explicitly return here, then the return value is just the message string, not the struct
    # maybe a good candidate for yield_self or tap?
    return @response
  end
end