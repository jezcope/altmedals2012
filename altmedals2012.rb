require 'camping'
require 'httpclient'
require 'json'

Camping.goes :AltMedals2012

module AltMedals2012::Models
  class Nation
    def initialize(name, code, gold, silver, bronze)
      @name = name
      @code = code
      @gold = gold
      @silver = silver
      @bronze = bronz
    end

    attr_accessor :name
    attr_accessor :code
    attr_accessor :gold
    attr_accessor :silver
    attr_accessor :bronze
  end
end

module AltMedals2012::Controllers
  class Index < R '/'
    def get
      render :index
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
    p "Hello world!"
  end
end
