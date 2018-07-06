defmodule PresencyWeb.UserControllerTest do
  use PresencyWeb.ConnCase

  alias Presency.Accounts

  @create_attrs %{avatar_img: "some avatar_img", display_name: "some display_name", email: "some email", fb_token: "some fb_token", first_name: "some first_name", ggl_token: "some ggl_token", last_name: "some last_name", password: "some password", username: "some username"}
  @update_attrs %{avatar_img: "some updated avatar_img", display_name: "some updated display_name", email: "some updated email", fb_token: "some updated fb_token", first_name: "some updated first_name", ggl_token: "some updated ggl_token", last_name: "some updated last_name", password: "some updated password", username: "some updated username"}
  @invalid_attrs %{avatar_img: nil, display_name: nil, email: nil, fb_token: nil, first_name: nil, ggl_token: nil, last_name: nil, password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new admin_user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create admin_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit admin_user" do
    setup [:create_user]

    test "renders form for editing chosen admin_user", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update admin_user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "some updated avatar_img"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete admin_user" do
    setup [:create_user]

    test "deletes chosen admin_user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
