require 'sinatra'
require 'httpclient'
require 'json'

require 'sinatra/reloader' if development?

require './models/nation.rb'

set :haml,      layout: :layout
set :markdown,  layout: :layout, layout_engine: :haml

get '/' do
  markdown :index
end

get '/standard' do
  @title = "Standard sort order"
  @description = "First by gold, then silver, then bronze"
  @nations = Nation.all_by_type
  @last_updated = Nation.last_updated
  haml :medal_table
end

get '/total' do
  @title = "Sorted by total medals"
  @description = "Total number of medals, regardless of colour"
  @nations = Nation.all_by_total
  @last_updated = Nation.last_updated
  haml :medal_table
end

get '/weighted/:x/:y/:z' do
  x = params[:x]
  y = params[:y]
  z = params[:z]
  @title = "Sorted with weighted total"
  @description = "Gold = #{x}, silver = #{y}, bronze = #{z}"
  @nations = Nation.all_by_weighted_total(x.to_i, y.to_i, z.to_i)
  @last_updated = Nation.last_updated
  haml :medal_table
end
