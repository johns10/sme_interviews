defmodule SmeInterviews.AnswersTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.Answers

  describe "answers" do
    alias SmeInterviews.Answers.Answer

    import SmeInterviews.AnswersFixtures

    @invalid_attrs %{body: nil, order: nil, selected: nil}

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Answers.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Answers.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{body: "some body", order: 42, selected: true}

      assert {:ok, %Answer{} = answer} = Answers.create_answer(valid_attrs)
      assert answer.body == "some body"
      assert answer.order == 42
      assert answer.selected == true
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Answers.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      update_attrs = %{body: "some updated body", order: 43, selected: false}

      assert {:ok, %Answer{} = answer} = Answers.update_answer(answer, update_attrs)
      assert answer.body == "some updated body"
      assert answer.order == 43
      assert answer.selected == false
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Answers.update_answer(answer, @invalid_attrs)
      assert answer == Answers.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Answers.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Answers.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Answers.change_answer(answer)
    end
  end
end
