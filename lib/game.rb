require "./lib/evaluate.rb"

class Game
  include Evaluate
  attr_reader :guesses, :code, :win

  def initialize
    @guesses = []
    @code = Array.new(4).map { rand(0..9) }.join
    @win = false
  end

  def make_attempt(guess)
    evaluation = evaluate(guess)
    @win = true if evaluation == "A4B0"
    @guesses << {guess => evaluation}
  end
end
