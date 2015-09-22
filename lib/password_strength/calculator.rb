module PasswordStrength
  # This class provides a password strength calculator.
  class Calculator
    LOWERCASE_LETTER = /[a-z]/
    UPPERCASE_LETTER = /[A-Z]/
    NUMBER = /\d/
    SYMBOL = /[$-\/:-?{-~!^_`\[\]]/

    MINIMUM_LENGTH = 8

    CONSECUTIVE_LOWERCASE = /(?=([a-z]{2}))/
    CONSECUTIVE_UPPERCASE = /(?=([A-Z]{2}))/
    CONSECUTIVE_NUMBERS = /(?=(\d{2}))/
    ONLY_NUMBERS = /\A[0-9]+\z/
    ONLY_LETTERS = /\A([a-z]|[A-Z])+\z$/

    LETTERS = 'abcdefghijklmnopqrstuvwxyz'
    NUMBERS = '0123456789'

    # FIXME: This string is incomplete and does not match 1:1 the regular
    # expression listed above but, follows the `ng-password-strength`
    # implementation.
    SYMBOLS = '\\!@#$%&/()=?¿'

    attr_reader :password

    def initialize(password)
      @password = password.to_s
    end

    extend Forwardable

    def_delegators :password, :length, :downcase

    def minimum_length?
      length >= MINIMUM_LENGTH
    end

    def lowercase_letters
      count LOWERCASE_LETTER
    end

    def uppercase_letters
      count UPPERCASE_LETTER
    end

    def numbers
      count NUMBER
    end

    def symbols
      count SYMBOL
    end

    REQUIRED_CONDITIONS = %i(
      uppercase_letters?
      lowercase_letters?
      numbers?
      symbols?
      minimum_length?
    )

    # FIXME: This unquestionably qualifies as the worst method name ever but,
    # follows the `ng-password-strength` implementation.
    def tmp
      REQUIRED_CONDITIONS.count do |name|
        send name
      end
    end

    def requirements
      tmp >= 3 ? tmp : 0
    end

    def middle_numbers
      count NUMBER, middle
    end

    def middle_symbols
      count SYMBOL, middle
    end

    def consecutive_lowercase
      count CONSECUTIVE_LOWERCASE
    end

    def consecutive_uppercase
      count CONSECUTIVE_UPPERCASE
    end

    def consecutive_numbers
      count CONSECUTIVE_NUMBERS
    end

    def only_letters
      count ONLY_LETTERS
    end

    def only_numbers
      count ONLY_NUMBERS
    end

    def sequential_letters
      count_sequence LETTERS, downcase
    end

    def sequential_numbers
      count_sequence NUMBERS
    end

    def sequential_symbols
      count_sequence SYMBOLS
    end

    def repeated
      count_repeated downcase
    end

    def repeated_ratio
      repeated.to_f / length
    rescue ZeroDivisionError
      0.0
    end

    %i(
      lowercase_letters
      uppercase_letters
      numbers
      symbols
      only_numbers
      only_letters
      repeated
    ).each do |name|
      define_method "#{name}?" do
        send(name) > 0
      end
    end

    def letters?
      lowercase_letters? || uppercase_letters?
    end

    def only_letters_or_numbers?
      only_letters? || only_numbers?
    end

    # Returns password strength as a number between 0 and 100.
    def strength
      [[score.round, 0].max, 100].min
    end

    private

    def scan(pattern, string = password)
      string.scan pattern
    end

    def count(pattern, string = password)
      scan(pattern, string).length
    end

    def middle
      password.slice(1..-2).to_s
    end

    def count_sequence(characters, string = password)
      count = 0
      0.upto(characters.length - 2) do |index|
        forth = characters.slice index, 3
        back = forth.reverse
        count += 1 if string.include?(forth) || string.include?(back)
      end
      count
    end

    def count_repeated(string)
      count = 0
      string.chars.each_with_index do |char, index|
        string.chars.each_with_index do |other_char, other_index|
          count += 1 if char == other_char && index != other_index
        end
      end
      count
    end

    def length_score
      length * 4
    end

    def lowercase_letters_score
      lowercase_letters? ? (length - lowercase_letters) * 2 : 0
    end

    def uppercase_letters_score
      uppercase_letters? ? (length - uppercase_letters) * 2 : 0
    end

    def numbers_score
      letters? ? numbers * 4 : 0
    end

    def symbols_score
      symbols * 6
    end

    def middle_score
      (middle_symbols + middle_numbers) * 2
    end

    def requirements_score
      requirements * 2
    end

    def consecutive_score
      (consecutive_lowercase + consecutive_uppercase + consecutive_numbers) * 2
    end

    def sequential_score
      (sequential_letters + sequential_numbers + sequential_symbols) * 3
    end

    def only_letters_or_numbers_score
      only_letters_or_numbers? ? length : 0
    end

    def repeated_score
      repeated? ? repeated_ratio * 10 : 0
    end

    def positive_score
      length_score +
      lowercase_letters_score +
      uppercase_letters_score +
      numbers_score +
      symbols_score +
      middle_score +
      requirements_score
    end

    def negative_score
      consecutive_score +
      sequential_score +
      only_letters_or_numbers_score +
      repeated_score
    end

    def score
      positive_score - negative_score
    end
  end
end
