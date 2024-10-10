defmodule NuugAgenda.Repo do
  use Ecto.Repo,
    otp_app: :nuug_agenda,
    adapter: Ecto.Adapters.MyXQL
end
