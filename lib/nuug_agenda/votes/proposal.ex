defmodule NuugAgenda.Votes.Proposal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "proposals" do
    field :title, :string
    field :description, :string, null: true, default: nil
    field :active, :boolean

    timestamps()
  end

  @doc false
  def changeset(proposal, attrs) do
    proposal
    |> cast(attrs, [:title, :description, :active])
    |> validate_required([:title, :active])
  end
end
