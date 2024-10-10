defmodule NuugAgenda.VotesTest do
  use NuugAgenda.DataCase

  alias NuugAgenda.Votes

  describe "proposals" do
    alias NuugAgenda.Votes.Proposal

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def proposal_fixture(attrs \\ %{}) do
      {:ok, proposal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Votes.create_proposal()

      proposal
    end

    test "list_proposals/0 returns all proposals" do
      proposal = proposal_fixture()
      assert Votes.list_proposals() == [proposal]
    end

    test "get_proposal!/1 returns the proposal with given id" do
      proposal = proposal_fixture()
      assert Votes.get_proposal!(proposal.id) == proposal
    end

    test "create_proposal/1 with valid data creates a proposal" do
      assert {:ok, %Proposal{} = proposal} = Votes.create_proposal(@valid_attrs)
      assert proposal.description == "some description"
      assert proposal.title == "some title"
    end

    test "create_proposal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.create_proposal(@invalid_attrs)
    end

    test "update_proposal/2 with valid data updates the proposal" do
      proposal = proposal_fixture()
      assert {:ok, %Proposal{} = proposal} = Votes.update_proposal(proposal, @update_attrs)
      assert proposal.description == "some updated description"
      assert proposal.title == "some updated title"
    end

    test "update_proposal/2 with invalid data returns error changeset" do
      proposal = proposal_fixture()
      assert {:error, %Ecto.Changeset{}} = Votes.update_proposal(proposal, @invalid_attrs)
      assert proposal == Votes.get_proposal!(proposal.id)
    end

    test "delete_proposal/1 deletes the proposal" do
      proposal = proposal_fixture()
      assert {:ok, %Proposal{}} = Votes.delete_proposal(proposal)
      assert_raise Ecto.NoResultsError, fn -> Votes.get_proposal!(proposal.id) end
    end

    test "change_proposal/1 returns a proposal changeset" do
      proposal = proposal_fixture()
      assert %Ecto.Changeset{} = Votes.change_proposal(proposal)
    end
  end

  describe "proposal_alternatives" do
    alias NuugAgenda.Votes.ProposalAlternative

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def proposal_alternative_fixture(attrs \\ %{}) do
      {:ok, proposal_alternative} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Votes.create_proposal_alternative()

      proposal_alternative
    end

    test "list_proposal_alternatives/0 returns all proposal_alternatives" do
      proposal_alternative = proposal_alternative_fixture()
      assert Votes.list_proposal_alternatives() == [proposal_alternative]
    end

    test "get_proposal_alternative!/1 returns the proposal_alternative with given id" do
      proposal_alternative = proposal_alternative_fixture()
      assert Votes.get_proposal_alternative!(proposal_alternative.id) == proposal_alternative
    end

    test "create_proposal_alternative/1 with valid data creates a proposal_alternative" do
      assert {:ok, %ProposalAlternative{} = proposal_alternative} =
               Votes.create_proposal_alternative(@valid_attrs)

      assert proposal_alternative.title == "some title"
    end

    test "create_proposal_alternative/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.create_proposal_alternative(@invalid_attrs)
    end

    test "update_proposal_alternative/2 with valid data updates the proposal_alternative" do
      proposal_alternative = proposal_alternative_fixture()

      assert {:ok, %ProposalAlternative{} = proposal_alternative} =
               Votes.update_proposal_alternative(proposal_alternative, @update_attrs)

      assert proposal_alternative.title == "some updated title"
    end

    test "update_proposal_alternative/2 with invalid data returns error changeset" do
      proposal_alternative = proposal_alternative_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Votes.update_proposal_alternative(proposal_alternative, @invalid_attrs)

      assert proposal_alternative == Votes.get_proposal_alternative!(proposal_alternative.id)
    end

    test "delete_proposal_alternative/1 deletes the proposal_alternative" do
      proposal_alternative = proposal_alternative_fixture()

      assert {:ok, %ProposalAlternative{}} =
               Votes.delete_proposal_alternative(proposal_alternative)

      assert_raise Ecto.NoResultsError, fn ->
        Votes.get_proposal_alternative!(proposal_alternative.id)
      end
    end

    test "change_proposal_alternative/1 returns a proposal_alternative changeset" do
      proposal_alternative = proposal_alternative_fixture()
      assert %Ecto.Changeset{} = Votes.change_proposal_alternative(proposal_alternative)
    end
  end

  describe "votes" do
    alias NuugAgenda.Votes.Vote

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def vote_fixture(attrs \\ %{}) do
      {:ok, vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Votes.create_vote()

      vote
    end

    test "list_votes/0 returns all votes" do
      vote = vote_fixture()
      assert Votes.list_votes() == [vote]
    end

    test "get_vote!/1 returns the vote with given id" do
      vote = vote_fixture()
      assert Votes.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote" do
      assert {:ok, %Vote{} = vote} = Votes.create_vote(@valid_attrs)
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{} = vote} = Votes.update_vote(vote, @update_attrs)
    end

    test "update_vote/2 with invalid data returns error changeset" do
      vote = vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Votes.update_vote(vote, @invalid_attrs)
      assert vote == Votes.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{}} = Votes.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> Votes.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset" do
      vote = vote_fixture()
      assert %Ecto.Changeset{} = Votes.change_vote(vote)
    end
  end
end
