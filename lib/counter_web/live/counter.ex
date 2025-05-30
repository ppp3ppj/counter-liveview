defmodule CounterWeb.Counter do
  use CounterWeb, :live_view
  alias Counter.Count
  alias Phoenix.PubSub
  alias Counter.Presence

  @topic Count.topic()
  @presence_topic "presence"

  def mount(_params, _session, socket) do
    initial_present =
      if connected?(socket) do
        PubSub.subscribe(Counter.PubSub, @topic)
        CounterWeb.Endpoint.subscribe(@presence_topic)
        Presence.track(self(), @presence_topic, socket.id, %{})

        Presence.list(@presence_topic) |> map_size()
      else
        0
      end

    {:ok, assign(socket, val: Count.current(), present: initial_present)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, assign(socket, :val, Count.incr())}
  end

  def handle_event("dec", _, socket) do
    {:noreply, assign(socket, :val, Count.decr())}
  end

  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, val: count)}
  end

  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{present: present}} = socket
      ) do
    {_, joins} = Map.pop(joins, socket.id, %{})

    changes = map_size(joins) - map_size(leaves)
    new_present = present + changes

    {:noreply, assign(socket, :present, new_present)}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={CounterPresenceStatComponent} id="cp_stat" val={@val} present={@present}/>
    """
  end
end
