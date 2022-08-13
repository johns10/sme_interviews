defmodule SmeInterviews.InterviewTemplatesTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.InterviewTemplates

  describe "interview_templates" do
    alias SmeInterviews.InterviewTemplates.InterviewTemplate

    import SmeInterviews.InterviewTemplatesFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_interview_templates/0 returns all interview_templates" do
      interview_template = interview_template_fixture()
      assert InterviewTemplates.list_interview_templates() == [interview_template]
    end

    test "get_interview_template!/1 returns the interview_template with given id" do
      interview_template = interview_template_fixture()
      assert InterviewTemplates.get_interview_template!(interview_template.id) == interview_template
    end

    test "create_interview_template/1 with valid data creates a interview_template" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %InterviewTemplate{} = interview_template} = InterviewTemplates.create_interview_template(valid_attrs)
      assert interview_template.description == "some description"
      assert interview_template.name == "some name"
    end

    test "create_interview_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InterviewTemplates.create_interview_template(@invalid_attrs)
    end

    test "update_interview_template/2 with valid data updates the interview_template" do
      interview_template = interview_template_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %InterviewTemplate{} = interview_template} = InterviewTemplates.update_interview_template(interview_template, update_attrs)
      assert interview_template.description == "some updated description"
      assert interview_template.name == "some updated name"
    end

    test "update_interview_template/2 with invalid data returns error changeset" do
      interview_template = interview_template_fixture()
      assert {:error, %Ecto.Changeset{}} = InterviewTemplates.update_interview_template(interview_template, @invalid_attrs)
      assert interview_template == InterviewTemplates.get_interview_template!(interview_template.id)
    end

    test "delete_interview_template/1 deletes the interview_template" do
      interview_template = interview_template_fixture()
      assert {:ok, %InterviewTemplate{}} = InterviewTemplates.delete_interview_template(interview_template)
      assert_raise Ecto.NoResultsError, fn -> InterviewTemplates.get_interview_template!(interview_template.id) end
    end

    test "change_interview_template/1 returns a interview_template changeset" do
      interview_template = interview_template_fixture()
      assert %Ecto.Changeset{} = InterviewTemplates.change_interview_template(interview_template)
    end
  end
end
