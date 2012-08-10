class Nation
  def initialize(params)
    @name   = params["country_name"]
    @code   = params["country_code"]
    @gold   = params["gold"].to_i
    @silver = params["silver"].to_i
    @bronze = params["bronze"].to_i
  end

  attr_accessor :name
  attr_accessor :code
  attr_accessor :gold
  attr_accessor :silver
  attr_accessor :bronze

  def total
    @gold + @silver + @bronze
  end

  def weighted_total(x, y, z)
    x*@gold + y*@silver + z*@gold
  end

  def all_medals
    [@gold, @silver, @bronze]
  end

  def to_s
    "Nation(#{@name}: #{@gold} gold, #{@silver} silver, #{@bronze} bronze)"
  end

  def self.all
    client = HTTPClient.new
    response = client.get('https://api.scraperwiki.com/api/1.0/datastore/sqlite?format=jsondict&name=london_2012_medal_table&query=select%20*%20from%20%60swdata%60')
    JSON[response.body].map {|x| Nation.new(x)}
  end

  def self.all_by_type
    self.all.sort_by {|nation| nation.all_medals}
  end

  def self.all_by_total
    self.all.sort_by {|nation| nation.total}
  end

  def self.all_by_weighted_total(x, y, z)
    self.all.sort_by {|nation| nation.weighted_total(x,y,z)}
  end

  def self.last_updated
    client = HTTPClient.new
    response = client.get('https://api.scraperwiki.com/api/1.0/scraper/getinfo?format=jsondict&name=london_2012_medal_table&version=-1')
    DateTime.parse(JSON[response.body][0]['last_run'])
  end
end

