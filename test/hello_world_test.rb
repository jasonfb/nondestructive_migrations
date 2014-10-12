require 'test_helper'
require 'minitest/autorun'

# this is simply a test to test the testing framework itself

class BasicTest < Minitest::Test
  def test_hello
    assert true
  end
end