defmodule Presency.AccountsTest do
  use Presency.DataCase

  alias Presency.Accounts

  describe "users" do
    alias Presency.Accounts.User

    @valid_attrs %{avatar_img: "some avatar_img", display_name: "some display_name", email: "some email", fb_token: "some fb_token", first_name: "some first_name", ggl_token: "some ggl_token", last_name: "some last_name", password: "some password", username: "some username"}
    @update_attrs %{avatar_img: "some updated avatar_img", display_name: "some updated display_name", email: "some updated email", fb_token: "some updated fb_token", first_name: "some updated first_name", ggl_token: "some updated ggl_token", last_name: "some updated last_name", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{avatar_img: nil, display_name: nil, email: nil, fb_token: nil, first_name: nil, ggl_token: nil, last_name: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar_img == "some avatar_img"
      assert user.display_name == "some display_name"
      assert user.email == "some email"
      assert user.fb_token == "some fb_token"
      assert user.first_name == "some first_name"
      assert user.ggl_token == "some ggl_token"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.avatar_img == "some updated avatar_img"
      assert user.display_name == "some updated display_name"
      assert user.email == "some updated email"
      assert user.fb_token == "some updated fb_token"
      assert user.first_name == "some updated first_name"
      assert user.ggl_token == "some updated ggl_token"
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
