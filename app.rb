require "sinatra"
require "sinatra/reloader" if development?
require "./lib/game.rb"

enable :sessions

get "/" do
  session.delete("game") if session["game"]
  erb :index
end

get "/:mode" do
  game_class = params["mode"] == "guess" ? GuessGame : AskGame
  session["game"] = session["game"].class == game_class ? session["game"] : game_class.new
  @game = session["game"]
  @history = @game.history
  @message = session.delete("message")
  erb :game
end

post "/:mode" do
  begin
    session["game"].make_attempt(params["input"])
  rescue InvalidInput
    session["message"] = "Попробуйте сделать ход по правилам"
  end
  redirect "/#{params["mode"]}"
end
