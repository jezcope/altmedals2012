require 'scraperwiki'
require 'nokogiri'

DATA_SOURCE_URL = "http://www.bbc.co.uk/sport/olympics/2012/medals/countries"

class Nation < Sequel::Model

  def total
    gold + silver + bronze
  end

  def to_s
    "Nation(#{name}: #{gold} gold, #{silver} silver, #{bronze} bronze)"
  end

  def self.all_by_type
    order(:gold, :silver, :bronze)
  end

  def self.all_by_total
    order{gold + silver + bronze}
  end

  def self.all_by_weighted_total(x, y, z)
    order{ self.*(x, gold) + self.*(y, silver) + self.*(z, bronze) }
  end

  def self.last_updated
    nation = order(:updated).last
    unless nation.nil?
      nation.updated
    else
      Time.new
    end
  end

  def self.scrape
    html = ScraperWiki::scrape(DATA_SOURCE_URL)
    doc = Nokogiri::HTML(html)

    doc.css('.medals-table').each do |table|
      table.css('tbody tr').each do |row|
        country_info = row.at_css('.country-text')
        code = country_info['data-country-code']

        nation = Nation.find_or_create(:code => code)
        nation.name = country_info['data-country-name']
        [:gold, :silver, :bronze].each do |medal|
          nation.set(medal => row.at_css("td.#{medal}").inner_html.to_i)
        end
        nation.updated = DateTime.now
        nation.save
      end
    end
  end

end

