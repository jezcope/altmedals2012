require 'camping'

Camping.goes :AltMedals2012

module AltMedals2012::Models
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
