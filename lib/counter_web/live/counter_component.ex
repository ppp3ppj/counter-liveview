defmodule CounterComponent do
  use Phoenix.LiveComponent

  # Avoid duplicating tailwind classes and show hot to inline a function call:
  def btn(color) do
    "text-6xl pb-2 w-20 rounded-lg bg-#{color}-500 hover:bg-#{color}-600"
  end

  def render(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="text-center text-4xl font-bold">Counter: <%= @val %> </h1>
      <p class="text-center">
        <button class={btn("red")} phx-click="dec">-</button>
        <button class={btn("green")} phx-click="inc">+</button>
      </p>
    </div>
    """
  end
end
