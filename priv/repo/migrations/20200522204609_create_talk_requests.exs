defmodule NuugAgenda.Repo.Migrations.CreateTalkRequests do
  use Ecto.Migration

  def change do
    create table(:talk_requests) do
      add :type, :string
      add :status, :string
      add :comment, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :talk_request_id, references(:talk_requests, on_delete: :nothing)

      timestamps()
    end

    create index(:talk_requests, [:user_id])
    create index(:talk_requests, [:talk_request_id])
  end
end
