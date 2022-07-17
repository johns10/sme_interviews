defmodule SmeInterviewsWeb.LiveHelpers do
  # import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

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

  def tooltip_bottom(%{text: text, inner_block: inner_block} = assigns) do
    tooltip_styles = "hidden group-hover:absolute group-hover:block rounded shadow-lg p-1 text-gray-300 bg-gray-800 border border-gray-200 dark:border-gray-700"
    ~H"""
    <div class="group">
      <%= render_slot(inner_block) %>
      <div class={tooltip_styles}>
        <%= text %>
      </div>
    </div>
    """
  end

  def tooltip_top(%{text: text, inner_block: inner_block} = assigns) do
    tooltip_styles = "hidden group-hover:absolute group-hover:block rounded shadow-lg p-1 text-gray-300 bg-gray-800 border border-gray-200 dark:border-gray-700"
    ~H"""
    <div class="group">
      <div class={tooltip_styles <> " -translate-y-full"}>
        <%= text %>
      </div>
      <%= render_slot(inner_block) %>
    </div>
    """
  end

  def tooltip_top_left(%{text: text, inner_block: inner_block} = assigns) do
    tooltip_styles = "hidden group-hover:absolute group-hover:block rounded shadow-lg p-1 text-gray-300 bg-gray-800 border border-gray-200 dark:border-gray-700"
    ~H"""
    <div class="group">
      <div class={tooltip_styles <> " -translate-y-full -translate-x-1/2"}>
        <%= text %>
      </div>
      <%= render_slot(inner_block) %>
    </div>
    """
  end

  def tooltip_left(%{text: text, inner_block: inner_block} = assigns) do
    tooltip_styles = "hidden group-hover:absolute group-hover:block rounded shadow-lg p-1 text-gray-300 bg-gray-800 border border-gray-200 dark:border-gray-700"
    ~H"""
    <div class="group">
      <div class={tooltip_styles <> " -translate-x-full"}>
        <%= text %>
      </div>
      <%= render_slot(inner_block) %>
    </div>
    """
  end
end
