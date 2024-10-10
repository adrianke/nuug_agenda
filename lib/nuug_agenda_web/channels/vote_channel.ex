defmodule NuugAgendaWeb.VoteChannel do
  use Phoenix.Channel

  def join("proposal:" <> _, _message, socket) do
    {:ok, socket}
  end
end
