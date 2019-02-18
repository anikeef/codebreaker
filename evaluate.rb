module Evaluate
  def evaluate(suggestion, answer = self.code)
    bulls = 0
    cows = 0
    right_digits = answer.split("")
    suggestion_digits = suggestion.split("")

    right_digits.each.with_index do |digit, index|
      if digit == suggestion_digits[index]
        bulls += 1
        right_digits[index] = "bull"
        suggestion_digits[index] = "bull"
      end
    end

    right_digits.each.with_index do |digit, index|
      cow = suggestion_digits.find { |sug_digit| sug_digit == digit && sug_digit != "bull" && sug_digit != "cow" }
      if cow
        cows += 1
        right_digits[index] = "cow"
        suggestion_digits[suggestion_digits.index(cow)] = "cow"
      end
    end
    
    "A#{bulls}B#{cows}"
  end
end
