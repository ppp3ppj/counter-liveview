defmodule CounterWeb.Counter do
  use CounterWeb, :live_view

  @topic "live"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      CounterWeb.Endpoint.subscribe(@topic)
    end
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _, socket) do
    new_state = update(socket, :val, &(&1 + 1))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, &(&1 - 1))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-center text-4xl font-bold">Counter: <%= @val %> </h1>
      <p class="text-center">
        <.button class="w-20 bg-red-500 hover:bg-red-600" phx-click="dec">-</.button>
        <.button class="w-20 bg-green-500 hover:bg-green-600" phx-click="inc">+</.button>
      </p>
    </div>
    """
  end
end
