require 'test_helper'

class PasswordStrengthTest < Minitest::Test
  def test_has_a_version_number
    refute_nil ::PasswordStrength::VERSION
  end

  def test_strength_for_nil
    assert_equal 0, ::PasswordStrength.strength_for(nil)
  end

  def test_strength_for_blank_password
    assert_equal 0, ::PasswordStrength.strength_for('')
  end

  def test_strength_for_weak_password
    assert_equal 5, ::PasswordStrength.strength_for('secret')
  end

  def test_strength_for_strong_password
    assert_equal 72, ::PasswordStrength.strength_for('rich605*eels')
  end
end
