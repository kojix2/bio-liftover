require_relative 'test_helper'

class TestLiftover < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::LiftOver::VERSION
  end
end
