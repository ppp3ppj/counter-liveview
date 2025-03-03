defmodule CounterComponent do
  use Phoenix.LiveComponent

  # Avoid duplicating tailwind classes and show hot to inline a function call:
  def btn(type) do
    "btn btn-active  btn-#{type} text-2xl btn-lg"
  end

  def render(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="text-center text-4xl font-bold">Counter: <%= @val %> </h1>
      <p class="text-center">
        <button class={btn("primary")} phx-click="dec">-</button>
        <button class={btn("error")} phx-click="inc">+</button>
      </p>
    </div>
    """
  end
end
