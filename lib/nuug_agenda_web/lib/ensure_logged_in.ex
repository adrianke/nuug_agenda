defmodule NuugAgendaWeb.EnsureLoggedIn do
  import Plug.Conn
  import Phoenix.Controller

  alias NuugAgenda.Accounts
  alias NuugAgenda.Accounts.User
  alias NuugAgendaWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if not is_nil(user_id) do
      case Accounts.get_user(user_id) do
        %User{} = user ->
          conn
          |> assign(:current_user, user)
          |> assign(:user_signed_in?, true)

        _ ->
          unauthrorized(conn)
      end
    else
      unauthrorized(conn)
    end
  end

  defp unauthrorized(conn) do
    conn
    |> put_flash(:error, "Du må oppgi nøkkel før du går videre")
    |> redirect(to: Routes.log_in_path(conn, :new))
    |> halt()
  end
end
