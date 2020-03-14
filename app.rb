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

events_table = DB.from(:events)
rsvps_table = DB.from(:rsvps)
users_table = DB.from(:users)


before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    view "new_user"
    
end


get "/events/all" do
    puts events_table.all
    @events = events_table.all.to_a
    @rsvps_table = DB.from(:reviews)
    view "events"
end

get "/events/:id" do
    @event = events_table.where(id: params[:id]).to_a[0]
    @rsvps = rsvps_table.where(event_id: @event[:id])
    @users_table = users_table
    @avg_overall = rsvps_table.where(event_id: @event[:id]).avg(:overall_rating)
    @avg_sound = rsvps_table.where(event_id: @event[:id]).avg(:sound_rating)
    @avg_vibe = rsvps_table.where(event_id: @event[:id]).avg(:vibe_rating)
    @avg_payout = rsvps_table.where(event_id: @event[:id]).avg(:payout_rating)
    view "event"
end

get "/event/:id/reviews/confirm" do
    if @current_user == nil
        rsvps_table.insert(event_id: params["id"],
                            user_id: 1,
                            overall_rating: params["overall_rating"],
                            sound_rating: params["sound_rating"],
                            vibe_rating: params["vibe_rating"],
                            payout_rating: params["payout_rating"],
                            comments: params["comments"])
    else   
        rsvps_table.insert(event_id: params["id"],
                            user_id: session["user_id"],
                            overall_rating: params["overall_rating"],
                            sound_rating: params["sound_rating"],
                            vibe_rating: params["vibe_rating"],
                            payout_rating: params["payout_rating"],
                            comments: params["comments"])
    end
    view "reviews_confirm"
end

get "/events/:id/rsvps/new" do
    @event = events_table.where(id: params[:id]).to_a[0]
    view "new_rsvp"
end

get "/events/:id/rsvps/create" do
    puts params
    @event = events_table.where(id: params["id"]).to_a[0]
    rsvps_table.insert(event_id: params["id"],
                       user_id: session["user_id"],
                       comments: params["comments"])
    view "create_rsvp"
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    puts params
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(name: params["name"], email: params["email"], password: hashed_password)
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