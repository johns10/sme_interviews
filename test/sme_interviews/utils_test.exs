defmodule SmeInterviews.UtilsTest do
  use ExUnit.Case
  doctest SmeInterviews.Utils
  alias SmeInterviews.Utils

  describe "take_two" do
    test "with two" do
      assert Utils.take_two([1, 2]) == [{1, 2}, {2, nil}]
    end

    test "with three" do
      assert Utils.take_two([1, 2, 3]) == [{1, 2}, {2, 3}, {3, nil}]
    end
  end
end
