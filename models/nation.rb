class Nation < Sequel::Model

  def total
    gold + silver + bronze
  end

  def weighted_total(x, y, z)
    x*gold + y*silver + z*gold
  end

  def all_medals
    [gold, silver, bronze]
  end

  def to_s
    "Nation(#{name}: #{gold} gold, #{silver} silver, #{bronze} bronze)"
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
    DateTime.new
  end

end

