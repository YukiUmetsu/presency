defmodule PresencyWeb.Admin.PostController do
  use PresencyWeb, :controller
  import PhoenixGon.Controller
  require IEx

  alias Presency.CMS
  alias Presency.CMS.Post
  import Helpers.String, only: [separate_words: 2]

  def index(conn, _params) do
    posts = CMS.list_posts()
    conn = add_posts_to_gon(conn, posts)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = CMS.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    require IEx
    new_meta_keywords = create_meta_keywords(post_params["meta_keywords"])
    new_tags= create_tags(post_params["tags"])

    case CMS.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: admin_post_path(conn, :show, post))

        # keyword and list does not match
        CMS.build_post_assoc(post, :tags, new_tags)
        CMS.build_post_assoc(post, :meta_keywords, new_meta_keywords)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    require IEx
    post = CMS.get_post_with_assoc!(id)
    conn = put_gon(conn, post_content: post.content)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = CMS.get_post!(id)
    changeset = CMS.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = CMS.get_post!(id)

    case CMS.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: admin_post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = CMS.get_post!(id)
    {:ok, _post} = CMS.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_post_path(conn, :index))
  end

  def create_meta_keywords(meta_keyrwords \\ "") do
    word_list = separate_words(meta_keyrwords, ",")
    CMS.create_meta_keywords_by_string_list(word_list)
  end

  def create_tags(tags \\ "") do
    word_list = separate_words(tags, ",")
    CMS.create_tags_by_string_list(word_list)
  end

  def add_posts_to_gon(conn, posts) do
    conn = add_post_to_gon(conn, posts, 0)
  end

  def add_post_to_gon(conn, posts, index) do
    post = Enum.at(posts, index)
    post_id = post.id
    key = "post-#{post_id}"
    post_map = %{key => post.content}
    conn = put_gon(conn, post_map)

    if next_index_exist?(posts, index) do
      conn = add_post_to_gon(conn, posts, index+1)
    end
    conn
  end

  def next_index_exist?(list, index) do
    next_element = Enum.at(list, index + 1)
    !is_nil(next_element)
  end
end
