defmodule PresencyWeb.Admin.PostController do
  use PresencyWeb, :controller
  import PhoenixGon.Controller

  alias Presency.CMS
  alias Presency.CMS.Post
  import Helpers.String, only: [separate_words: 2]
  require IEx

  def index(conn, _params) do
    categories = CMS.list_categories()
    posts = CMS.list_posts()
    conn = add_posts_to_gon(conn, posts)
    render(conn, "index.html", posts: posts, categories: categories)
  end

  def new(conn, _params) do
    categories = CMS.list_category_options()
    changeset = CMS.change_post(%Post{})
    page = CMS.list_paginated_images(1, 8)
    admin_user = conn.assigns.current_admin
    token = Phoenix.Token.sign(conn, "socket_login", admin_user.id)

    render(conn, "new.html",
      changeset: changeset,
      categories: categories,
      token: token,
      page: page,
      images: page.entries
    )
  end

  def create(conn, %{"post" => post_params}) do
    new_tags = create_tags(post_params["tags"])
    category = CMS.get_category(post_params["category_id"])
    categories = CMS.list_category_options()

    post_create_result =
      post_params
      |> CMS.build_post_param_assoc(category)
      |> CMS.create_post_from_changeset

    case post_create_result do
      {:ok, post} ->
        post = CMS.build_many_many_post_assoc(post, :tags, new_tags)
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: admin_post_path(conn, :edit, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          categories: categories
        )
    end
  end

  def show(conn, %{"id" => id}) do
    categories = CMS.list_categories()
    post = CMS.get_post_with_assoc!(id)
    conn = put_gon(conn, post_content: post.content)
    render(conn, "show.html", post: post, categories: categories)
  end

  def edit(conn, %{"id" => id}) do
    categories = CMS.list_category_options()
    post = CMS.get_post_with_assoc!(id)
    changeset = CMS.change_post(post)
    page = CMS.list_paginated_images(1, 8)
    admin_user = conn.assigns.current_admin
    token = Phoenix.Token.sign(conn, "socket_login", admin_user.id)
    render(conn, "edit.html",
      post: post,
      changeset: changeset,
      categories: categories,
      token: token,
      page: page,
      images: page.entries
    )
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = CMS.get_post_with_assoc!(id)
    tags = get_tags_list(post_params["tags"])
    image = CMS.get_image(post_params["image"])
    category = CMS.get_category(post_params["category_id"])

    post_params =
      Map.delete(post_params, "tags")
      |> Map.put("image", image.id)

    case CMS.update_post_with_multi_assoc(post, post_params, image, tags, category) do
      {:error, %Ecto.Changeset{} = changeset} ->
        categories = CMS.list_category_options()
        page = CMS.list_paginated_images(1, 8)
        admin_user = conn.assigns.current_admin
        token = Phoenix.Token.sign(conn, "socket_login", admin_user.id)
        render(conn, "edit.html",
          post: post,
          changeset: changeset,
          categories: categories,
          admin_user: admin_user,
          page: page,
          token: token
        )

      post ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: admin_post_path(conn, :show, post))
    end
  end

  def delete(conn, %{"id" => id}) do
    post = CMS.get_post!(id)
    {:ok, _post} = CMS.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_post_path(conn, :index))
  end

  def create_tags(tags \\ "") do
    word_list = separate_words(tags, ",")
    CMS.create_tags_by_string_list(word_list)
  end

  def add_posts_to_gon(conn, posts) do
    case Blankable.blank?(posts) do
      false -> add_post_to_gon(conn, posts, 0)
      true -> conn
    end
  end

  def add_post_to_gon(conn, posts, index) do
    post = Enum.at(posts, index)
    post_id = post.id
    key = "post-#{post_id}"
    post_map = %{key => post.content}
    conn = put_gon(conn, post_map)

    case next_index_exist?(posts, index) do
      true -> add_post_to_gon(conn, posts, index+1)
      false -> conn
    end
  end

  def next_index_exist?(list, index) do
    next_element = Enum.at(list, index + 1)
    !is_nil(next_element)
  end

  def get_tags_list(tags_string\\"") do
    Helpers.String.split_trim(tags_string, ",")
    |> Enum.map(fn x -> %{title: x} end)
  end
end
