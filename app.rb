require "sinatra"
require "sinatra/reloader" if development?
require "./lib/game.rb"

enable :sessions

get "/" do
  session.delete("game") if session["game"]
  erb :index
end

get "/:mode" do
  if params["mode"] == "pvc"
    session["game"] = session["game"].class == PvC ? session["game"] : PvC.new
  else
    session["game"] = session["game"].class == CvP ? session["game"] : CvP.new
  end
  @game = session["game"]
  redirect "/#{params["mode"]}/win" if @game.win
  @guesses = @game.guesses
  erb :game
end

post "/:mode" do
  session["game"].make_attempt(params["guess"])
  redirect "/#{params["mode"]}"
end

get "/pvc/win" do
  redirect "/" unless session["game"] && session["game"].win
  @game = session.delete("game")
  "Win! The answer is #{@game.code}!"
end

get "/cvp/win" do
  redirect "/" unless session["game"] && session["game"].win
  session.delete("game")
  "Computer broke your code!"
end
