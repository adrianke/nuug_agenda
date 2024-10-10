defmodule NuugAgendaWeb.IndexController do
  use NuugAgendaWeb, :controller
  require Logger

  import Phoenix.Controller
  alias NuugAgendaWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.agenda_path(conn, :index))
  end
end
