defmodule SmeInterviews.QuestionsTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.Questions
  alias SmeInterviews.QuestionTemplatesFixtures

  describe "questions" do
    alias SmeInterviews.Questions.Question

    import SmeInterviews.QuestionsFixtures

    @invalid_attrs %{body: nil, status: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{body: "some body", status: :open}

      assert {:ok, %Question{} = question} = Questions.create_question(valid_attrs)
      assert question.body == "some body"
      assert question.status == :open
    end

    test "create_question/1 with an question template creates an question" do
      assert {:ok, %Question{} = question} =
               QuestionTemplatesFixtures.question_template_fixture()
               |> Questions.create_question()

      assert question.body == "some body"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{body: "some updated body", status: :closed}

      assert {:ok, %Question{} = question} = Questions.update_question(question, update_attrs)
      assert question.body == "some updated body"
      assert question.status == :closed
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
