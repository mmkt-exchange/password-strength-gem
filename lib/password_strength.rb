require 'password_strength/calculator'
require 'password_strength/version'

module PasswordStrength
  extend self

  # Returns password strength as a number between 0 and 100.
  def strength_for(password)
    Calculator.new(password).strength
  end
end
