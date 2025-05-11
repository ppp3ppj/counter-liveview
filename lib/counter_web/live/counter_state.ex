defmodule Counter.Count do
  use GenServer
  alias Phoenix.PubSub
  @name :count_server

  @start_value 0

  # External API (runs in client process)

  def topic do
    "count"
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def incr() do
    GenServer.call(@name, :incr)
  end

  def decr() do
    GenServer.call(@name, :decr)
  end

  def current() do
    GenServer.call(@name, :current)
  end

  def init(start_count) do
    {:ok, start_count}
  end

  # Implementation (Runs in GenServer process)
  def handle_call(:current, _from, count) do
    {:reply, count, count}
  end

  def handle_call(:incr, _from, count) do
    make_change(count, +1)
  end

  @doc """
  Handles the `:decr` call by attempting to decrement the current count.

  ## Parameters
    - `:decr`: The message to decrement the count.
    - `_from`: The caller information (unused).
    - `count`: The current count (integer

  ## Behavior
    - If `count - 1` is less than 0, the function raises a `RuntimeError` with the message `"Count cannot be negative"`.
    - Otherwise, it calls `make_change/2` with `count` and `-1` to decrement the value.

  ## Raises
    - `RuntimeError` if decrementing the count would result in a negative number.
  """
  def handle_call(:decr, _from, count) do
    if count - 1 < 0 do
      raise "Count cannot be negative"
    end

    make_change(count, -1)
  end

  defp make_change(count, change) do
    new_count = count + change
    PubSub.broadcast(Counter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end
end
