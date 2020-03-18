# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :events do
  primary_key :id
  String :event_name
  String :address
  String :website
  String :email
  String :phone
end
DB.create_table! :ratings do
  primary_key :id
  foreign_key :event_id
  foreign_key :user_id
  Integer :overall_rating
  Integer :food_quality_rating
  Integer :vibe_rating
  Integer :food_variety_rating
  String :comments, text: true
end

DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
events_table = DB.from(:events)

events_table.insert(event_name: "Teriyaki Bowl", 
                    address: "718 Taylor Ave N, Seattle, WA 98109",
                    website: "http://teriyakibowl-qa.com/",
                    email: "replace@replace.com",
                    phone: "(206) 285-8344")

events_table.insert(event_name: "Gourmet Teriyaki", 
                   address: "7671 SE 27th St, Mercer Island, WA 98040",
                    website: "https://www.yelp.com/biz/gourmet-teriyaki-mercer-island-2",
                    email: "replace@replace.com",
                    phone: "(206) 232-0580")

events_table.insert(event_name: "Toshio's Teriyaki", 
                    address: "1706 Rainier Ave S, Seattle, WA 98144",
                    website: "http://www.toshiosteriyaki.com/",
                    email: "replace@replace.com",
                    phone: "(206) 323-6303")

events_table.insert(event_name: "University Teriyaki", 
                    address: "4108 The Ave, Seattle, WA 98105",
                    website: "https://www.tripadvisor.com/Restaurant_Review-g60878-d2529210-Reviews-University_Teriyaki-Seattle_Washington.html",
                    email: "replace@replace.com",
                    phone: "(206) 632-5688")

users_table = DB.from(:users)

users_table.insert(name: "Anonymous", 
                    email: "anonymous@musiciansguide.com",
                    password: "anonymous")
