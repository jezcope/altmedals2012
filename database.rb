require 'sinatra/sequel'

set :database, ENV['DATABASE_URL'] || 'sqlite://db/altmedals2012.db'

migration "create the nations table" do
  database.create_table :nations do
    primary_key :id
    String :name
    String :code, index: {unique: true}
    Integer :gold
    Integer :silver
    Integer :bronze
  end
end

migration "add updated field to nation" do
  database.alter_table :nations do
    add_column :updated, DateTime
  end
end
