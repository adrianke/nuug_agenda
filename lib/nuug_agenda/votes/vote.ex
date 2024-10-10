defmodule NuugAgenda.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :proposal_alternative_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:proposal_alternative_id, :user_id])
    |> validate_required([:proposal_alternative_id, :user_id])
    |> unique_constraint(:vote_constraint, name: :vote_constraint)
  end
end
