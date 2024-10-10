defmodule NuugAgenda.Agenda.TalkRequest do
  use Ecto.Schema
  import Ecto.Changeset
  alias NuugAgenda.Accounts.User

  schema "talk_requests" do
    field :comment, :string
    field :status, :string
    field :type, :string
    belongs_to :user, User
    field :talk_request_id, :id

    timestamps()
  end

  @doc false
  def changeset(talk_request, attrs) do
    talk_request
    |> cast(attrs, [:type, :status, :comment, :user_id, :talk_request_id])
    |> validate_required([:type, :status, :user_id])
  end
end
