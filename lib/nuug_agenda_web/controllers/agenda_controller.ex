defmodule NuugAgendaWeb.AgendaController do
  use NuugAgendaWeb, :controller

  import Plug.Conn
  import Phoenix.Controller

  alias NuugAgenda.Agenda
  alias NuugAgendaWeb.AgendaView
  alias NuugAgendaWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    token = Phoenix.Token.sign(NuugAgendaWeb.Endpoint, "user_id", conn.assigns.current_user.id)

    render(conn, "index.html",
      talk_requests: Agenda.list_active_talk_requests(),
      socket_token: token
    )
  end

  def respond(conn, %{"talk_request_id" => talk_request_id}) do
    render(conn, "form.html", talk_request_id: talk_request_id, csrf_token: get_csrf_token())
  end

  def new(conn, _params) do
    render(conn, "form.html", talk_request_id: nil, csrf_token: get_csrf_token())
  end

  def create(conn, params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    type =
      cond do
        is_nil(params["talk_request_id"]) -> "main"
        params["type"] == "reply" -> "reply"
        params["type"] == "fact" -> "fact"
      end

    case Agenda.create_talk_request(%{
           user_id: user_id,
           type: type,
           talk_request_id: params["talk_request_id"],
           status: "new"
           # comment: params["comment"]
         }) do
      {:ok, _} ->
        NuugAgendaWeb.Endpoint.broadcast("agenda", "update", %{
          html:
            Phoenix.View.render_to_string(AgendaView, "talk_requests.html",
              talk_requests: Agenda.list_active_talk_requests(),
              conn: conn
            )
        })

        conn
        |> put_flash(:success, "Lagret")
        |> redirect(to: Routes.agenda_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Det oppsto en feil")
        |> redirect(to: Routes.agenda_path(conn, :index))
    end
  end
end
