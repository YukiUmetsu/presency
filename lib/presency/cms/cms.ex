defmodule Presency.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias Presency.Repo
  alias Presency.CMS.Post
  alias Presency.CMS.MainSettings
  alias Presency.CMS.Category
  alias Presency.CMS.Tag
  alias Presency.CMS.Image
  import Helpers.String, only: [trim_string_list: 1]
  require IEx

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def list_paginated_posts(page_number, page_size) do
    query = from p in Post, order_by: [desc: p.updated_at], preload: [:category, :image, :tags]
    Repo.paginate(query, page: page_number, page_size: page_size)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:tags)
    |> Repo.preload(:category)
    |> Repo.preload(:image)
  end

  def get_post_with_assoc!(id) do
    query = from p in Post, where: p.id == ^id
    Repo.one(query)
    |> Repo.preload(:tags)
    |> Repo.preload(:category)
    |> Repo.preload(:image)
  end

  def get_post_by_url_id(url_id) do
    query = from p in Post, where: p.url_id == ^url_id
    Repo.one(query)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def create_post_from_changeset(changeset) do
    changeset |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def update_post_with_multi_assoc(post, post_params, image, tags, category) do
    post
    |> add_tag_assoc_to_post(tags)
    |> Post.changeset(post_params)
    |> add_image_assoc_to_post(image)
    |> add_category_assoc_to_post(category)
    |> Repo.update
  end

  def add_tag_assoc_to_post(post, tags) do
    case tags do
      nil -> post
      [] -> post
      _ -> post |> build_many_many_post_assoc(:tags, tags)
    end
  end

  def add_image_assoc_to_post(post, image) do
    case image do
      nil -> post
      [] -> post
      _ -> post |> Ecto.Changeset.put_assoc(:image, image)
    end
  end

  def add_category_assoc_to_post(post, category) do
    case category do
      nil -> post
      [] -> post
      _ ->
        post |> Ecto.Changeset.put_assoc(:category, category)
    end
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  def build_many_many_post_assoc(post, keyword, list) do
    with false <- Blankable.blank?(post),
         false <- Blankable.blank?(keyword),
         false <- Blankable.blank?(list)
    do
      post
      |> Repo.preload(keyword)
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(keyword, list)
      |> Repo.update!
    else
      _ -> post
    end
  end

  def build_post_param_assoc(post_param \\ %{}, item) do
    with false <- Blankable.blank?(post_param),
          false <- Blankable.blank?(item)
    do
      post_param = create_post_param(post_param)
      Ecto.build_assoc(item, :posts, post_param)
      |> Post.changeset(post_param)
    else
      _ -> Post.changeset(%Post{}, post_param)
    end
  end

  def build_post_assoc(item, post_params) do
    Ecto.build_assoc(item, :posts, post_params)
  end

  def create_post_param(params \\ %{}) do
    Map.drop(params, ["tags", "image", "category_id"])
  end

  alias Presency.CMS.Comment

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  def list_paginated_comments(page_number, page_size) do
    query = from c in Comment, order_by: [desc: c.updated_at], preload: [:user, :post]
    Repo.paginate(query, page: page_number, page_size: page_size)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories() do
    query = from c in Category, order_by: c.id
    Repo.all(query)
  end

  def list_paginated_categories(page_number, page_size) do
    query = from c in Category, order_by: [asc: c.id], preload: [:parent_category]
    Repo.paginate(query, page: page_number, page_size: page_size)
  end

  def list_category_options() do
    case list_categories() do
      nil -> nil
      categories -> categories |> Enum.map(fn(category) -> [value: category.id, key: category.title] end)
    end
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id) do
    case Blankable.blank?(id) do
        false -> Repo.get!(Category, id)
        true -> nil
    end
  end

  def get_category(id) do
    case Blankable.blank?(id) do
      false -> Repo.get(Category, id)
      true -> nil
    end
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end


  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Comment{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  def get_tag_by_title(title) do
    Tag |> Repo.get_by(title: title)
  end

  def create_tags_by_string_list(tags \\ []) do
    results = tags
      |> trim_string_list
      |> Enum.map(fn(tag) -> create_tag_by_string(tag) end)
      |> Enum.filter(& !is_nil(&1))

    case Blankable.blank?(results) do
      false -> results
      true -> nil
    end
  end

  def create_tag_by_string(tag \\ "") do
    existing_tag = get_tag_by_title(tag)
    with {false, true} <- {Blankable.blank?(tag), Blankable.blank?(existing_tag)}
      do
      {:ok, new_tag} = create_tag(%{"title"=>tag})
      new_tag |> Repo.preload(:posts)
    else
      _ -> existing_tag
    end
  end

  def get_new_tags_from_list(nil), do: nil

  def get_new_tags_from_list([]), do: nil

  def get_new_tags_from_list(tags) when is_list(tags) do
    Enum.map(tags, fn(tag) ->
      existing_tag = get_tag_by_title(tag.title)
      case existing_tag do
        nil -> tag
        _ -> nil
      end
    end)
    |> Enum.filter(fn(x) -> x != nil end)
  end

  def load_tags_from_post_params(post_params) do
    case post_params["tags"] || [] do
      [] -> :tags
      _tags ->
        tag_list = post_params["tags"] |> String.split(",") |> Enum.map(fn x -> String.trim(x) end)
        tag_list |> create_tags_by_string_list

        case Repo.all from t in Tag, where: t.title in ^tag_list do
          nil -> []
          [] -> []
          tags -> tags
        end
    end
  end

  def list_main_settings() do
    Repo.one(from x in MainSettings, order_by: [asc: x.id], limit: 1)
  end

  def get_main_settings(id) do
    case Blankable.blank?(id) do
      false -> Repo.get!(MainSettings, id)
      true -> nil
    end
  end

  def create_main_settings(attrs \\ %{}) do
    %MainSettings{}
    |> MainSettings.changeset(attrs)
    |> Repo.insert()
  end

  def update_main_settings(%MainSettings{} = settings, attrs) do
    settings
    |> MainSettings.changeset(attrs)
    |> Repo.update()
  end

  def change_main_settings(%MainSettings{} = settings) do
    MainSettings.changeset(settings, %{})
  end



  def list_image() do
    query = from i in Image, order_by: [desc: i.updated_at]
    Repo.all(query)
  end

  def get_image(""), do: nil
  def get_image(nil), do: nil
  def get_image(id) do
    query = from i in Image, where: i.id == ^id
    Repo.one(query)
  end

  def list_paginated_images(page_number \\ 1, page_size \\ 7) do
    query = from i in Image, order_by: [desc: i.updated_at]
    Repo.paginate(query, page: page_number, page_size: page_size)
  end

  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

end
