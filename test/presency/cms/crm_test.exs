defmodule Presency.CMSTest do
  use Presency.DataCase

  alias Presency.CMS

  describe "posts" do
    alias Presency.CMS.Post

    @valid_attrs %{content: "some content", publicity: "some publicity", title: "some title"}
    @update_attrs %{content: "some updated content", publicity: "some updated publicity", title: "some updated title"}
    @invalid_attrs %{content: nil, publicity: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert CMS.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert CMS.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = CMS.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.publicity == "some publicity"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = CMS.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.publicity == "some updated publicity"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_post(post, @invalid_attrs)
      assert post == CMS.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = CMS.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = CMS.change_post(post)
    end
  end

  describe "comments" do
    alias Presency.CMS.Comment

    @valid_attrs %{by_admin: 42, content: "some content"}
    @update_attrs %{by_admin: 43, content: "some updated content"}
    @invalid_attrs %{by_admin: nil, content: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert CMS.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert CMS.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = CMS.create_comment(@valid_attrs)
      assert comment.by_admin == 42
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = CMS.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.by_admin == 43
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_comment(comment, @invalid_attrs)
      assert comment == CMS.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = CMS.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = CMS.change_comment(comment)
    end
  end
end
