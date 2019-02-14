require "sinatra"
require "sinatra/reloader" if development?
require "./lib/game.rb"

enable :sessions

get "/" do
  session.delete("game") if session["game"]
  erb :index
end

get "/:mode" do
  if params["mode"] == "guess"
    session["game"] = session["game"].class == GuessGame ? session["game"] : GuessGame.new
  else
    session["game"] = session["game"].class == AskGame ? session["game"] : AskGame.new
  end
  @game = session["game"]
  redirect "/#{params["mode"]}/win" if @game.win
  @guesses = @game.guesses
  erb :game
end

post "/:mode" do
  session["game"].make_attempt(params["input"])
  redirect "/#{params["mode"]}"
end

get "/guess/win" do
  redirect "/" unless session["game"] && session["game"].win
  @game = session.delete("game")
  "Win! The answer is #{@game.code}!"
end

get "/ask/win" do
  redirect "/" unless session["game"] && session["game"].win
  session.delete("game")
  "Computer broke your code!"
end
