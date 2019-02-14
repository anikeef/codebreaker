require "./lib/evaluate.rb"

class Game
  include Evaluate
  attr_reader :guesses, :win

  def initialize
    @guesses = []
    @win = false
  end
end

class GuessGame < Game
  attr_reader :code

  def initialize
    super()
    @code = Array.new(4).map { rand(0..9) }.join
  end

  def make_attempt(guess)
    evaluation = evaluate(guess)
    @guesses << [guess, evaluation]
    @win = true if evaluation == "A4B0"
  end
end

class AskGame < Game
  def initialize
    super()
    make_attempt
  end

  def make_attempt(evaluation = nil)
    answers = (0..9999).map { |num| num.to_s.rjust(4, "0") }
    if evaluation
      if evaluation.upcase == "A4B0"
        @win = true
        return
      end
      @guesses.last[1] = evaluation.upcase
      @guesses.each do |guess_record, evaluation_record|
        answers.select! { |answer| evaluate(answer, guess_record) == evaluation_record }
      end
    end
    @guesses << [answers.sample, nil]
  end
end
