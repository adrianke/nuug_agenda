defmodule NuugAgendaWeb.VoteController do
  use NuugAgendaWeb, :controller
  require Logger

  import Plug.Conn
  import Phoenix.Controller

  alias NuugAgenda.Votes
  alias NuugAgenda.Votes.Proposal
  alias NuugAgenda.Votes.ProposalAlternative
  alias NuugAgenda.Votes.Vote
  alias NuugAgendaWeb.VoteView
  alias NuugAgendaWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    render(conn, "list.html", proposals: Votes.list_proposals())
  end

  def show(conn, %{"proposal_id" => proposal_id}) do
    token = Phoenix.Token.sign(NuugAgendaWeb.Endpoint, "user_id", conn.assigns.current_user.id)

    render(conn, "index.html",
      proposal: Votes.get_proposal(proposal_id),
      proposal_alternatives: Votes.list_proposal_alternatives_by_proposal_id(proposal_id),
      votes: Votes.list_votes_by_proposal_id(proposal_id),
      socket_token: token,
      csrf_token: get_csrf_token()
    )
  end

  def export(conn, _params) do
    list =
      Votes.list_proposals()
      |> Enum.map(fn proposal ->
        %{
          proposal: proposal,
          proposal_alternatives: Votes.list_proposal_alternatives_by_proposal_id(proposal.id),
          votes: Votes.list_votes_by_proposal_id(proposal.id)
        }
      end)

    render(conn, "export.html", list: list)
  end

  def cast_vote(conn, %{"alternative" => alternative_id}) do
    with(
      {alternative_id, _} <- Integer.parse(alternative_id),
      %ProposalAlternative{} = alternative <- Votes.get_proposal_alternative(alternative_id),
      %Proposal{} = proposal <- Votes.get_proposal(alternative.proposal_id),
      true <- proposal.active,
      {:ok, {:ok, %Vote{}}} <-
        Votes.upsert_vote(alternative.id, Plug.Conn.get_session(conn, :current_user_id))
    ) do
      NuugAgendaWeb.Endpoint.broadcast("proposal:#{proposal.id}", "update", %{
        html:
          Phoenix.View.render_to_string(VoteView, "votes.html",
            votes: Votes.list_votes_by_proposal_id(proposal.id),
            conn: conn
          )
      })

      conn
      |> put_flash(:success, "Stemme avgitt")
      |> redirect(to: Routes.vote_path(conn, :show, proposal.id))
    else
      obj ->
        Logger.warn(inspect(obj))

        conn
        |> put_flash(:error, "En feil oppsto")
        |> redirect(to: Routes.agenda_path(conn, :index))
    end
  end
end
