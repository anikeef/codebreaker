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
  @guesses = @game.guesses
  @message = session.delete("message")
  redirect "/#{params["mode"]}/win" if @game.win
  erb :game
end

post "/:mode" do
  begin
    session["game"].make_attempt(params["input"])
  rescue InvalidInput
    session["message"] = "Invalid input, try again"
  rescue EvalMistake
    session["message"] = "It looks like you've made a mistake in some of your evaluations"
  end
  redirect "/#{params["mode"]}"
end

get "/guess/win" do
  redirect "/" unless session["game"] && session["game"].win
  @game = session.delete("game")
  @message = "Win! The answer is #{@game.code}!"
  erb :gameover
end

get "/ask/win" do
  redirect "/" unless session["game"] && session["game"].win
  session.delete("game")
  @message = "Computer broke your code!"
  erb :gameover
end
