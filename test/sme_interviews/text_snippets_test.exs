defmodule SmeInterviews.TextSnippetsTest do
  use ExUnit.Case
  alias SmeInterviews.TextSnippets

  describe "TextSnippets" do
    test "get_random_text_snippet gets a random text snippet" do
      assert TextSnippets.get_random_text_snippet() == "Test text snippet."
    end
  end
end
