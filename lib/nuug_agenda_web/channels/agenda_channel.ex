defmodule NuugAgendaWeb.AgendaChannel do
  use Phoenix.Channel

  def join("agenda", _message, socket) do
    {:ok, socket}
  end
end
