require 'test_helper'

class CalculatorTest < Minitest::Test
  def instance
    @instance ||= PasswordStrength::Calculator.new('secret')
  end

  def test_returns_instance
    assert instance
  end

  def test_has_password_accessor
    assert_equal 'secret', instance.password
  end
end
