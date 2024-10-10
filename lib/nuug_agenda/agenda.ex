defmodule NuugAgenda.Agenda do
  @moduledoc """
  The Agenda context.
  """

  import Ecto.Query, warn: false
  alias NuugAgenda.Repo

  alias NuugAgenda.Agenda.TalkRequest

  @doc """
  Returns the list of talk_requests.

  ## Examples

      iex> list_talk_requests()
      [%TalkRequest{}, ...]

  """
  def list_talk_requests do
    Repo.all(TalkRequest)
  end

  def list_active_talk_requests do
    list_talk_requests()
    |> Repo.preload(:user)
    |> Enum.group_by(
      fn tr ->
        cond do
          is_nil(tr.talk_request_id) -> tr.id
          true -> tr.talk_request_id
        end
      end,
      & &1
    )
    |> Enum.map(fn {_id, requests} ->
      data =
        requests
        |> Enum.sort(fn a, b ->
          cond do
            is_nil(a.talk_request_id) -> true
            is_nil(b.talk_request_id) -> false
            true -> a.id < b.id
          end
        end)
        |> Enum.filter(fn r ->
          r.type == "main" or (r.type != "main" and r.status != "archived")
        end)

      if length(data) == 1 and List.first(data).status == "archived" do
        nil
      else
        data
      end
    end)
    |> Enum.filter(&(not is_nil(&1)))
  end

  @doc """
  Gets a single talk_request.

  Raises `Ecto.NoResultsError` if the Talk request does not exist.

  ## Examples

      iex> get_talk_request!(123)
      %TalkRequest{}

      iex> get_talk_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_talk_request!(id), do: Repo.get!(TalkRequest, id)

  @doc """
  Creates a talk_request.

  ## Examples

      iex> create_talk_request(%{field: value})
      {:ok, %TalkRequest{}}

      iex> create_talk_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_talk_request(attrs \\ %{}) do
    %TalkRequest{}
    |> TalkRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a talk_request.

  ## Examples

      iex> update_talk_request(talk_request, %{field: new_value})
      {:ok, %TalkRequest{}}

      iex> update_talk_request(talk_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_talk_request(%TalkRequest{} = talk_request, attrs) do
    talk_request
    |> TalkRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a talk_request.

  ## Examples

      iex> delete_talk_request(talk_request)
      {:ok, %TalkRequest{}}

      iex> delete_talk_request(talk_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_talk_request(%TalkRequest{} = talk_request) do
    Repo.delete(talk_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking talk_request changes.

  ## Examples

      iex> change_talk_request(talk_request)
      %Ecto.Changeset{source: %TalkRequest{}}

  """
  def change_talk_request(%TalkRequest{} = talk_request) do
    TalkRequest.changeset(talk_request, %{})
  end
end
