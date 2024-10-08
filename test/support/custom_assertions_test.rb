require 'minitest/autorun'
require_relative 'custom_assertions'

class CustomAssertionsTest < Minitest::Test
  include CustomAssertions

  def test_assert_same_elements_with_identical_arrays
    a1 = [1, 2, 2, 3]
    a2 = [2, 3, 1, 2]
    assert_same_elements(a1, a2)
  end

  def test_assert_same_elements_with_different_arrays
    a1 = [1, 2, 3]
    a2 = [1, 2, 4]
    assert_raises(Minitest::Assertion) do
      assert_same_elements(a1, a2)
    end
  end
end
