# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################


restaurants_table = DB.from(:restaurants)
ratings_table = DB.from(:ratings)
users_table = DB.from(:users)


before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    view "new_user"
end


get "/restaurants/all" do
    puts restaurants_table.all
    @restaurants = restaurants_table.all.to_a
    @ratings_table = DB.from(:reviews)
    view "restaurants"
end

get "/restaurants/:id" do
    @restaurant = restaurants_table.where(id: params[:id]).to_a[0]
    @ratings = ratings_table.where(restaurant_id: @restaurant[:id])
    @users_table = users_table
    @avg_overall = ratings_table.where(restaurant_id: @restaurant[:id]).avg(:overall_rating)
    @avg_food_quality = ratings_table.where(restaurant_id: @restaurant[:id]).avg(:food_quality_rating)
    @avg_ambiance = ratings_table.where(restaurant_id: @restaurant[:id]).avg(:ambiance_rating)
    @avg_food_variety = ratings_table.where(restaurant_id: @restaurant[:id]).avg(:food_variety_rating)
    view "restaurant"
end

get "/restaurant/:id/reviews/confirm" do
    if @current_user == nil
        ratings_table.insert(restaurant_id: params["id"],
                            user_id: 1,
                            overall_rating: params["overall_rating"],
                            food_quality_rating: params["food_quality_rating"],
                            ambiance_rating: params["ambiance_rating"],
                            food_variety_rating: params["food_variety_rating"],
                            comments: params["comments"])
    else   
        ratings_table.insert(restaurant_id: params["id"],
                            user_id: session["user_id"],
                            overall_rating: params["overall_rating"],
                            food_quality_rating: params["food_quality_rating"],
                            ambiance_rating: params["ambiance_rating"],
                            food_variety_rating: params["food_variety_rating"],
                            comments: params["comments"])
    end

    view "reviews_confirm"
end

get "/restaurants/:id/ratings/new" do
    @restaurant = restaurants_table.where(id: params[:id]).to_a[0]
    view "new_ratings"
end

get "/restaurants/:id/ratings/create" do
    puts params
    @restaurant = restaurants_table.where(id: params["id"]).to_a[0]
    ratings_table.insert(restaurant_id: params["id"],
                       user_id: session["user_id"],
                       comments: params["comments"])
    view "create_ratings"
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    puts params
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(name: params["name"], email: params["email"], password: hashed_password)

    # account_sid = ENV["TWILIO_ACCOUNT_SID"]
    # auth_token = ENV["TWILIO_AUTH_TOKEN"]
    # client = Twilio::REST::Client.new(account_sid, auth_token)
    # client.messages.create(
    # from: "+12029329915", 
    # to: "+12067796004",
    # body: "A new user has created an account on Teriyaki Hub!"
    # )
    
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    user = users_table.where(email: params["email"]).to_a[0]
    puts BCrypt::Password::new(user[:password])
    if user && BCrypt::Password::new(user[:password]) == params["password"]
        session["user_id"] = user[:id]
        @current_user = user
        view "create_login"
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    @current_user = nil
    view "logout"
end

