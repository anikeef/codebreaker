require "./lib/evaluate.rb"

class InvalidInput < StandardError; end
class EvalMistake < StandardError; end

class Game
  include Evaluate
  attr_reader :history, :win

  def initialize
    @history = []
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
    raise InvalidInput unless valid_input?(guess)
    evaluation = evaluate(guess)
    @history << [guess, evaluation]
    @win = true if evaluation == "A4B0"
  end

  def valid_input?(input)
    /^\d{4}$/.match?(input)
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
      raise InvalidInput unless valid_input?(evaluation)
      if /a4b0/i.match?(evaluation)
        @win = true
        return
      end
      @history.last[1] = evaluation.upcase
      @history.each do |guess_record, evaluation_record|
        answers.select! { |answer| evaluate(answer, guess_record) == evaluation_record }
      end
      raise EvalMistake if answers.empty?
    end

    @history << [answers.sample, nil]
  end

  def valid_input?(input)
    /^[aа][01234][bв][01234]$/i.match?(input)
  end
end
