defmodule NuugAgenda.Votes.ProposalAlternative do
  use Ecto.Schema
  import Ecto.Changeset

  schema "proposal_alternatives" do
    field :title, :string
    field :proposal_id, :id

    timestamps()
  end

  @doc false
  def changeset(proposal_alternative, attrs) do
    proposal_alternative
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
