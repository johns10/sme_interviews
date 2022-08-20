defmodule SmeInterviews.TextSnippets do
  def get_random_text_snippet() do
    file_location()
    |> File.ls!()
    |> Enum.random()
    |> then(&Path.join(file_location(), &1))
    |> File.read!()
    |> String.split("\n")
    |> Enum.random()
  end

  defp file_location() do
    Application.get_env(:sme_interviews, __MODULE__)
    |> Keyword.get(:location)
    |> then(&Application.app_dir(:sme_interviews, &1))
  end
end
