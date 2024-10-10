defmodule NuugAgenda.Repo.Migrations.UserEmail do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :email, :text
    end
  end
end
