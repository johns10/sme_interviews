defmodule SmeInterviews.QuestionTemplatesTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.QuestionTemplates

  describe "question_template" do
    alias SmeInterviews.QuestionTemplates.QuestionTemplate

    import SmeInterviews.QuestionTemplatesFixtures

    @invalid_attrs %{body: nil}

    test "list_question_template/0 returns all question_template" do
      question_template = question_template_fixture()
      assert QuestionTemplates.list_question_template() == [question_template]
    end

    test "get_question_template!/1 returns the question_template with given id" do
      question_template = question_template_fixture()
      assert QuestionTemplates.get_question_template!(question_template.id) == question_template
    end

    test "create_question_template/1 with valid data creates a question_template" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %QuestionTemplate{} = question_template} = QuestionTemplates.create_question_template(valid_attrs)
      assert question_template.body == "some body"
    end

    test "create_question_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = QuestionTemplates.create_question_template(@invalid_attrs)
    end

    test "update_question_template/2 with valid data updates the question_template" do
      question_template = question_template_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %QuestionTemplate{} = question_template} = QuestionTemplates.update_question_template(question_template, update_attrs)
      assert question_template.body == "some updated body"
    end

    test "update_question_template/2 with invalid data returns error changeset" do
      question_template = question_template_fixture()
      assert {:error, %Ecto.Changeset{}} = QuestionTemplates.update_question_template(question_template, @invalid_attrs)
      assert question_template == QuestionTemplates.get_question_template!(question_template.id)
    end

    test "delete_question_template/1 deletes the question_template" do
      question_template = question_template_fixture()
      assert {:ok, %QuestionTemplate{}} = QuestionTemplates.delete_question_template(question_template)
      assert_raise Ecto.NoResultsError, fn -> QuestionTemplates.get_question_template!(question_template.id) end
    end

    test "change_question_template/1 returns a question_template changeset" do
      question_template = question_template_fixture()
      assert %Ecto.Changeset{} = QuestionTemplates.change_question_template(question_template)
    end
  end
end
