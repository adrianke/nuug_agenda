defmodule NuugAgenda.Votes do
  @moduledoc """
  The Votes context.
  """

  import Ecto.Query, warn: false
  alias NuugAgenda.Repo

  alias NuugAgenda.Votes.Proposal

  @doc """
  Returns the list of proposals.

  ## Examples

      iex> list_proposals()
      [%Proposal{}, ...]

  """
  def list_proposals do
    Repo.all(Proposal)
  end

  @doc """
  Gets a single proposal.

  Raises `Ecto.NoResultsError` if the Proposal does not exist.

  ## Examples

      iex> get_proposal!(123)
      %Proposal{}

      iex> get_proposal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_proposal!(id), do: Repo.get!(Proposal, id)
  def get_proposal(id), do: Repo.get(Proposal, id)

  @doc """
  Creates a proposal.

  ## Examples

      iex> create_proposal(%{field: value})
      {:ok, %Proposal{}}

      iex> create_proposal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_proposal(attrs \\ %{}) do
    %Proposal{}
    |> Proposal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a proposal.

  ## Examples

      iex> update_proposal(proposal, %{field: new_value})
      {:ok, %Proposal{}}

      iex> update_proposal(proposal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_proposal(%Proposal{} = proposal, attrs) do
    proposal
    |> Proposal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a proposal.

  ## Examples

      iex> delete_proposal(proposal)
      {:ok, %Proposal{}}

      iex> delete_proposal(proposal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_proposal(%Proposal{} = proposal) do
    Repo.delete(proposal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking proposal changes.

  ## Examples

      iex> change_proposal(proposal)
      %Ecto.Changeset{source: %Proposal{}}

  """
  def change_proposal(%Proposal{} = proposal) do
    Proposal.changeset(proposal, %{})
  end

  alias NuugAgenda.Votes.ProposalAlternative

  @doc """
  Returns the list of proposal_alternatives.

  ## Examples

      iex> list_proposal_alternatives()
      [%ProposalAlternative{}, ...]

  """
  def list_proposal_alternatives do
    Repo.all(ProposalAlternative)
  end

  def list_proposal_alternatives_by_proposal_id(proposal_id) do
    from(pa in ProposalAlternative, where: pa.proposal_id == ^proposal_id)
    |> Repo.all()
  end

  @doc """
  Gets a single proposal_alternative.

  Raises `Ecto.NoResultsError` if the Proposal alternative does not exist.

  ## Examples

      iex> get_proposal_alternative!(123)
      %ProposalAlternative{}

      iex> get_proposal_alternative!(456)
      ** (Ecto.NoResultsError)

  """
  def get_proposal_alternative!(id), do: Repo.get!(ProposalAlternative, id)
  def get_proposal_alternative(id), do: Repo.get(ProposalAlternative, id)

  @doc """
  Creates a proposal_alternative.

  ## Examples

      iex> create_proposal_alternative(%{field: value})
      {:ok, %ProposalAlternative{}}

      iex> create_proposal_alternative(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_proposal_alternative(attrs \\ %{}) do
    %ProposalAlternative{}
    |> ProposalAlternative.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a proposal_alternative.

  ## Examples

      iex> update_proposal_alternative(proposal_alternative, %{field: new_value})
      {:ok, %ProposalAlternative{}}

      iex> update_proposal_alternative(proposal_alternative, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_proposal_alternative(%ProposalAlternative{} = proposal_alternative, attrs) do
    proposal_alternative
    |> ProposalAlternative.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a proposal_alternative.

  ## Examples

      iex> delete_proposal_alternative(proposal_alternative)
      {:ok, %ProposalAlternative{}}

      iex> delete_proposal_alternative(proposal_alternative)
      {:error, %Ecto.Changeset{}}

  """
  def delete_proposal_alternative(%ProposalAlternative{} = proposal_alternative) do
    Repo.delete(proposal_alternative)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking proposal_alternative changes.

  ## Examples

      iex> change_proposal_alternative(proposal_alternative)
      %Ecto.Changeset{source: %ProposalAlternative{}}

  """
  def change_proposal_alternative(%ProposalAlternative{} = proposal_alternative) do
    ProposalAlternative.changeset(proposal_alternative, %{})
  end

  alias NuugAgenda.Votes.Vote

  @doc """
  Returns the list of votes.

  ## Examples

      iex> list_votes()
      [%Vote{}, ...]

  """
  def list_votes do
    Repo.all(Vote)
  end

  @doc """
  Gets a single vote.

  Raises `Ecto.NoResultsError` if the Vote does not exist.

  ## Examples

      iex> get_vote!(123)
      %Vote{}

      iex> get_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vote!(id), do: Repo.get!(Vote, id)
  def get_vote(id), do: Repo.get(Vote, id)

  @doc """
  Creates a vote.

  ## Examples

      iex> create_vote(%{field: value})
      {:ok, %Vote{}}

      iex> create_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vote(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  def upsert_vote(proposal_alternative_id, user_id) do
    Repo.transaction(fn ->
      proposal_alternative = get_proposal_alternative(proposal_alternative_id)

      from(p in Proposal,
        left_join: pa in ProposalAlternative,
        on: pa.proposal_id == p.id,
        left_join: v in Vote,
        on: v.proposal_alternative_id == pa.id,
        where: v.user_id == ^user_id,
        where: p.id == ^proposal_alternative.proposal_id,
        select: v
      )
      |> Repo.one()
      |> case do
        nil ->
          create_vote(%{proposal_alternative_id: proposal_alternative_id, user_id: user_id})

        %Vote{} = vote ->
          update_vote(vote, %{proposal_alternative_id: proposal_alternative.id})
      end
    end)
  end

  @doc """
  Updates a vote.

  ## Examples

      iex> update_vote(vote, %{field: new_value})
      {:ok, %Vote{}}

      iex> update_vote(vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vote.

  ## Examples

      iex> delete_vote(vote)
      {:ok, %Vote{}}

      iex> delete_vote(vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vote(%Vote{} = vote) do
    Repo.delete(vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vote changes.

  ## Examples

      iex> change_vote(vote)
      %Ecto.Changeset{source: %Vote{}}

  """
  def change_vote(%Vote{} = vote) do
    Vote.changeset(vote, %{})
  end

  alias NuugAgenda.Accounts.User

  def list_votes_by_proposal_id(proposal_id) do
    from(p in Proposal,
      left_join: pa in ProposalAlternative,
      on: pa.proposal_id == p.id,
      left_join: v in Vote,
      on: v.proposal_alternative_id == pa.id,
      left_join: u in User,
      on: u.id == v.user_id,
      where: p.id == ^proposal_id,
      select: %{
        user_name: u.name,
        proposal_alternative_title: pa.title
      },
      order_by: [pa.id, u.name]
    )
    |> Repo.all()
    |> Enum.group_by(& &1.proposal_alternative_title, & &1.user_name)
  end
end
