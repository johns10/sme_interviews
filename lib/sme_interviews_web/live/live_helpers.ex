defmodule SMEInterviewsWeb.LiveHelpers do
  # import Phoenix.LiveView
  # import Phoenix.LiveView.Helpers

  def safe_create(items, item) do
    Enum.reduce(items, false, fn inner_item, acc ->
      acc || inner_item.id == item.id
    end)
    |> case do
      true -> items
      false -> items ++ [item]
    end
  end

  def safe_update(items, item) do
    Enum.map(items, fn inner_item ->
      if inner_item.id == item.id do
        item
      else
        inner_item
      end
    end)
  end
end
