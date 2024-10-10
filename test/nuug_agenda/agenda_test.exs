defmodule NuugAgenda.AgendaTest do
  use NuugAgenda.DataCase

  alias NuugAgenda.Agenda

  describe "talk_requests" do
    alias NuugAgenda.Agenda.TalkRequest

    @valid_attrs %{comment: "some comment", status: "some status", type: "some type"}
    @update_attrs %{comment: "some updated comment", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{comment: nil, status: nil, type: nil}

    def talk_request_fixture(attrs \\ %{}) do
      {:ok, talk_request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Agenda.create_talk_request()

      talk_request
    end

    test "list_talk_requests/0 returns all talk_requests" do
      talk_request = talk_request_fixture()
      assert Agenda.list_talk_requests() == [talk_request]
    end

    test "get_talk_request!/1 returns the talk_request with given id" do
      talk_request = talk_request_fixture()
      assert Agenda.get_talk_request!(talk_request.id) == talk_request
    end

    test "create_talk_request/1 with valid data creates a talk_request" do
      assert {:ok, %TalkRequest{} = talk_request} = Agenda.create_talk_request(@valid_attrs)
      assert talk_request.comment == "some comment"
      assert talk_request.status == "some status"
      assert talk_request.type == "some type"
    end

    test "create_talk_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agenda.create_talk_request(@invalid_attrs)
    end

    test "update_talk_request/2 with valid data updates the talk_request" do
      talk_request = talk_request_fixture()
      assert {:ok, %TalkRequest{} = talk_request} = Agenda.update_talk_request(talk_request, @update_attrs)
      assert talk_request.comment == "some updated comment"
      assert talk_request.status == "some updated status"
      assert talk_request.type == "some updated type"
    end

    test "update_talk_request/2 with invalid data returns error changeset" do
      talk_request = talk_request_fixture()
      assert {:error, %Ecto.Changeset{}} = Agenda.update_talk_request(talk_request, @invalid_attrs)
      assert talk_request == Agenda.get_talk_request!(talk_request.id)
    end

    test "delete_talk_request/1 deletes the talk_request" do
      talk_request = talk_request_fixture()
      assert {:ok, %TalkRequest{}} = Agenda.delete_talk_request(talk_request)
      assert_raise Ecto.NoResultsError, fn -> Agenda.get_talk_request!(talk_request.id) end
    end

    test "change_talk_request/1 returns a talk_request changeset" do
      talk_request = talk_request_fixture()
      assert %Ecto.Changeset{} = Agenda.change_talk_request(talk_request)
    end
  end
end
