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
  String :reviews, text: true
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
                    description: "This family owned teriyaki restaurant is a Seattle staple, and the best that can be found in Queen Anne. Sandwiched between a Domino's Pizza and Plaid Pantry, their meat is intentionally less fatty than other locations, and their homemade spicy sauce is a must-try!",
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

restaurants_table.insert(restaurant_name: "Yummy Bites", 
                    description: "This restaurant can't just be called a teriyaki place, because it also serves almost anything imaginable on its robust and diverse menu. But the teriyaki influence is evident, and the flavors make this place a University District destination.",
                    address: "4129 University Way NE, Seattle, WA 98105",
                    website: "https://www.zomato.com/seattle/yummy-bites-university-district/menu",
                    phone: "(206) 633-6582")

restaurants_table.insert(restaurant_name: "Teriyaki 1st", 
                    description: "Teriyaki 1st is yet another university hot spot. With its vast menue and delicious entrees, it's well worth the visit to the north Ave.",
                    address: "5201 University Way NE B, Seattle, WA 98105",
                    website: "https://www.yelp.com/biz/teriyaki-1st-seattle-2",
                    phone: "(206) 526-1661")

restaurants_table.insert(restaurant_name: "Ohana", 
                    description: "While not traditionally known for teriyaki, Ohana offeres a wide range of Japanese influenced cuisine. THough the variety is limited, their spicy teriyaki chicken is one of the best dishes on the menu.",
                    address: "2207 1st Ave, Seattle, WA 98121",
                    website: "https://www.yelp.com/biz/ohana-belltown-seattle",
                    phone: "(206) 956-9329")

restaurants_table.insert(restaurant_name: "Ichiro Sushi & Teriyaki", 
                    description: "Hidden in the secluded neighborhood of Magnolia, not let this little gem fall off of your radar. It's been serving quality teriyaki for years and is well worth the off the beaten path location.",
                    address: "2434 32nd Ave W, Seattle, WA 98199",
                    website: "https://www.yelp.com/biz/ichiro-sushi-and-teriyaki-seattle",
                    phone: "(206) 286-8755")

restaurants_table.insert(restaurant_name: "Sunny Teriyaki Ballard", 
                    description: "This is Ballard's most popular teriyaki joint. With a central location, it's alway bustling. They recently expanded to a second location just south of the locks on the Magnolia / Queen Anne border.",
                    address: "2035 NW Market St, Seattle, WA 98107",
                    website: "https://www.yelp.com/biz/sunny-teriyaki-seattle-5",
                    phone: "(206) 781-7838")

restaurants_table.insert(restaurant_name: "Yasuko's Teriyaki", 
                    description: "Yasuko's is situated on the west slope of Queen Anne hill. While parking can be difficult at this busy intersection, the restaurant is a popular destination for residents in the surrounding area.",
                    address: "3200 15th Ave W, Seattle, WA 98119",
                    website: "https://www.yelp.com/biz/yasukos-teriyaki-seattle-5",
                    phone: "(206) 283-0116")

users_table = DB.from(:users)

users_table.insert(name: "Anonymous", 
                    email: "anonymous@musiciansguide.com",
                    password: "anonymous")
