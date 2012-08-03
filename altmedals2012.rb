require 'camping'
require 'httpclient'
require 'json'

Camping.goes :AltMedals2012

module AltMedals2012::Models
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
      JSON[response.body][0]['last_run']
    end
  end
end

module AltMedals2012::Controllers
  class Index < R '/'
    def get
      render :index
    end
  end

  class Standard
    def get
      @title = "Standard sort order"
      @description = "First by gold, then silver, then bronze"
      @nations = Nation.all_by_type
      @last_updated = Nation.last_updated
      render :medal_table
    end
  end

  class Total
    def get
      @title = "Sorted by total medals"
      @description = "Total number of medals, regardless of colour"
      @nations = Nation.all_by_total
      @last_updated = Nation.last_updated
      render :medal_table
    end
  end

  class WeightedNNN
    def get(x, y, z)
      @title = "Sorted with weighted total"
      @description = "Gold = #{x}, silver = #{y}, bronze = #{z}"
      @nations = Nation.all_by_weighted_total(x.to_i, y.to_i, z.to_i)
      @last_updated = Nation.last_updated
      render :medal_table
    end
  end
end

module AltMedals2012::Views
  def layout
    html do
      head { title "Alternative medals table" }
      body { self << yield }
    end
  end

  def index
    h1 "Alternative medal tables"
    p "The olympic medal table is always sorted by gold first, then by silver,
      then by bronze. But what happens if we sort it in different ways?"
    ul do
      li { a "Standard medal table",  href: R(Standard) }
      li { a "Sorted by total",       href: R(Total) }
      li { a "Sorted with weights 3/2/1", href: R(WeightedNNN, 3, 2, 1) }
      li { a "Sorted with weights 4/2/1", href: R(WeightedNNN, 4, 2, 1) }
    end
    p do
      a "Fork it on GitHub", href: 'http://github.com/jezcope/altmedals2012'
    end
  end

  def medal_table
    h1 @title
    p.description @description
    table do
      thead do
        tr { th "Name"; th "Gold"; th "Silver"; th "Bronze"; th "Total" }
      end
      tbody do
        @nations.reverse_each do |nation|
          tr id: nation.code do
            td.country_name nation.name
            td.gold         nation.gold
            td.silver       nation.silver
            td.bronze       nation.bronze
            td.total        nation.total
          end
        end
      end
    end
    p "Data last updated #{@last_updated}"
  end
end
