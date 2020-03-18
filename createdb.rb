# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :restaurants do
  primary_key :id
  String :restaurant_name
  String :description
  String :website
  String :address
  String :phone
end
DB.create_table! :ratings do
  primary_key :id
  foreign_key :restaurant_id
  foreign_key :user_id
  Integer :overall_rating
  Integer :food_quality_rating
  Integer :ambiance_rating
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
restaurants_table = DB.from(:restaurants)

restaurants_table.insert(restaurant_name: "Teriyaki Bowl", 
                    description: "This family owned teriyaki restaurant is a Seattle staple, and the best that can be found in Queen Anne. Their meat is intentionally less fatty than other locations, and their homemade spicy sauce is a must-try!",
                    address: "718 Taylor Ave N, Seattle, WA 98109",
                    website: "http://teriyakibowl-qa.com/",
                    phone: "(206) 285-8344")

restaurants_table.insert(restaurant_name: "Gourmet Teriyaki", 
                    description: "While the interior may not be much to look at, the food more than makes up for it. This restaurant hasn't changed in decades (and that's a good thing!). Start a rewards card and hang it on their wall so you don't have to carry it with you as you earn your way to a free meal!",
                    address: "7671 SE 27th St, Mercer Island, WA 98040",
                    website: "https://www.yelp.com/biz/gourmet-teriyaki-mercer-island-2",
                    phone: "(206) 232-0580")

restaurants_table.insert(restaurant_name: "Toshio's Teriyaki", 
                    description: "Serving the Rainier Valley since 2002, this couple owned restaruant boasts the juiciest teriyaki in the region.",
                    address: "1706 Rainier Ave S, Seattle, WA 98144",
                    website: "http://www.toshiosteriyaki.com/",
                    phone: "(206) 323-6303")

restaurants_table.insert(restaurant_name: "University Teriyaki", 
                    description: "Arguably the most frequented teriyaki joint in the University district, University Teriyaki attracts a large portion of college students because of its tasty entrees and affordable prices.",
                    address: "4108 The Ave, Seattle, WA 98105",
                    website: "https://www.tripadvisor.com/Restaurant_Review-g60878-d2529210-Reviews-University_Teriyaki-Seattle_Washington.html",
                    phone: "(206) 632-5688")

users_table = DB.from(:users)

users_table.insert(name: "Anonymous", 
                    email: "anonymous@musiciansguide.com",
                    password: "anonymous")
