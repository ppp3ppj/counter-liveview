defmodule CounterPresenceStatComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex justify-center p-6">
      <div class="stats shadow-xl bg-base-100 border border-base-300">
        <div class="stat">
          <div class="stat-title">Current clients</div>
          <div class="stat-value">📊 {@present}</div>
          <div class="stat-actions">
            <button class="btn btn-xs btn-success" onclick="window.open('/', '_blank')">
              Add tabs
            </button>
          </div>
        </div>

        <div class="stat">
          <div class="stat-title">Current value</div>
          <div class="stat-value">🐣 {@val}</div>
          <div class="stat-actions">
            <button class="btn btn-xs" phx-click="inc">Increament</button>
            <button class="btn btn-xs" phx-click="dec">Decreament</button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
