require "./evaluate.rb"

class InvalidInput < StandardError; end

class Game
  include Evaluate
  attr_reader :history, :gameover_message, :attempts_left

  def initialize
    @history = []
    @gameover_message = nil
    @attempts_left = 12
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
    @attempts_left -= 1
    @gameover_message = "Победа! Секретный код #{@code}!" if evaluation == "A4B0"
    @gameover_message = "У вас закончились попытки. Секретный код #{@code}" if @attempts_left == 0
  end

  def valid_input?(input)
    /^\d{4}$/.match?(input)
  end

  def history
    @history + [[nil, nil]]
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
      @history.last[1] = evaluation.upcase
      if /[аa]4[bв]0/i.match?(evaluation)
        @gameover_message = "Компьютер знает ваш код!"
        return
      end
      @history.each do |guess_record, evaluation_record|
        answers.select! { |answer| evaluate(answer, guess_record) == evaluation_record }
      end
    end

    if answers.empty?
      @gameover_message = "Вы где-то ошиблись"
      return
    end
    @history << [answers.sample, nil]
  end

  def valid_input?(input)
    /^[aа][01234][bв][01234]$/i.match?(input)
  end
end
