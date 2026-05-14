defmodule SmeInterviews.Utils do
  def take_two([]), do: []
  def take_two(list), do: take_two(list, [])

  def take_two([head], acc) do
    [{head, nil} | acc]
  end

  def take_two([head, next | tail] = l, acc) do
    [{head, next} | take_two([next | tail], acc)]
  end
end
