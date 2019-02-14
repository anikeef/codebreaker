require "sinatra"
require "sinatra/reloader" if development?
require "./lib/game.rb"

enable :sessions

get "/" do
  session["game"] ||= Game.new
  @game = session["game"]
  redirect "/win" if @game.win
  @guesses = @game.guesses
  erb :index
end

post "/index.html" do
  session["game"].make_attempt(params["guess"])
  redirect "/"
end

get "/win" do
  redirect "/" unless session["game"] && session["game"].win
  @game = session.delete("game")
  "Win! The answer is #{@game.code}!"
end
