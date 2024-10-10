defmodule NuugAgendaWeb.LogInController do
  use NuugAgendaWeb, :controller
  import Plug.Conn
  require Logger

  alias NuugAgenda.Accounts
  alias NuugAgenda.Accounts.User
  alias NuugAgendaWeb.Router.Helpers, as: Routes

  def new(conn, _params) do
    render(conn, "index.html", csrf_token: get_csrf_token())
  end

  def create(conn, %{"key" => input}) do
    with(
      [user_id, key] <- String.split(input, ":"),
      {user_id, _} <- Integer.parse(user_id),
      %User{} = user <- Accounts.get_user(user_id),
      true <- Accounts.verify_password(user, key)
    ) do
      conn
      |> put_session(:current_user_id, user.id)
      |> redirect(to: Routes.agenda_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Ugyldig innlogging")
        |> redirect(to: Routes.log_in_path(conn, :new))
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:current_user_id, nil)
    |> redirect(to: Routes.log_in_path(conn, :new))
  end
end
