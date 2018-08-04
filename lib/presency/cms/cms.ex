defmodule Presency.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias Presency.Repo
  alias Presency.CMS.Post
  alias Presency.CMS.MainSettings
  import Helpers.String, only: [trim_string_list: 1]

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
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
  def get_post!(id), do: Repo.get!(Post, id)


  def get_post_with_assoc!(id) do
    query = from p in Post, where: p.id == ^id
    Repo.one(query)
    |> Repo.preload(:tags)
    |> Repo.preload(:meta_keywords)
    |> Repo.preload(:category)
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
    require IEx
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

  def build_post_assoc(post_param \\ %{}, item) do
    require IEx
    with false <- Blankable.blank?(post_param),
          false <- Blankable.blank?(item)
    do
      post_param = create_post_param(post_param)
      Ecto.build_assoc(item, :posts, post_param)
      |> Post.changeset(post_param)
    else
      _ -> Ecto.Changeset.change(%Post{}, post_param)
    end
  end

  def create_post_param(params \\ %{}) do
    %{
      "title" => params["title"],
      "content" => params["content"],
      "meta_description" => params["meta_description"],
      "publicity" => params["publicity"],
    }
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


  alias Presency.CMS.Category

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


  def list_category_options do
    case list_categories() do
      nil -> nil
      categories -> categories |> Enum.map(fn(category) -> ["value": category.id, "key": category.title] end)
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


  alias Presency.CMS.Tag

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


  alias Presency.CMS.MetaKeyword

  @doc """
  Returns the list of meta_keywords.

  ## Examples

      iex> list_meta_keywords()
      [%Comment{}, ...]

  """
  def list_meta_keywords do
    Repo.all(MetaKeyword)
  end

  @doc """
  Gets a single meta_keyword.

  Raises `Ecto.NoResultsError` if the MetaKeyword does not exist.

  ## Examples

      iex> get_meta_keyword!(123)
      %MetaKeyword{}

      iex> get_meta_keyword!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meta_keyword!(id), do: Repo.get!(MetaKeyword, id)

  @doc """
  Creates a meta_keyword.

  ## Examples

      iex> create_meta_keyword(%{field: value})
      {:ok, %MetaKeyword{}}

      iex> create_meta_keyword(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meta_keyword(attrs \\ %{}) do
    %MetaKeyword{}
    |> MetaKeyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meta_keyword.

  ## Examples

      iex> update_meta_keyword(meta_keyword, %{field: new_value})
      {:ok, %MetaKeyword{}}

      iex> update_meta_keyword(meta_keyword, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meta_keyword(%MetaKeyword{} = meta_keyword, attrs) do
    meta_keyword
    |> MetaKeyword.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MetaKeyword.

  ## Examples

      iex> delete_meta_keyword(meta_keyword)
      {:ok, %MetaKeyword{}}

      iex> delete_meta_keyword(meta_keyword)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meta_keyword(%MetaKeyword{} = meta_keyword) do
    Repo.delete(meta_keyword)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meta_keyword changes.

  ## Examples

      iex> change_meta_keyword(meta_keyword)
      %Ecto.Changeset{source: %MetaKeyword{}}

  """
  def change_meta_keyword(%MetaKeyword{} = meta_keyword) do
    MetaKeyword.changeset(meta_keyword, %{})
  end

  def build_post_keywords_assoc(%Post{} = post, meta_keywords) do
    post_changeset = Ecto.Changeset.change(post)
    post_with_tags = Ecto.Changeset.put_assoc(post_changeset, :meta_keywords, meta_keywords)
    Repo.update!(post_with_tags)
  end

  def create_meta_keywords_by_string_list(keywords \\ []) do
    results = keywords
              |> trim_string_list
              |> Enum.map(fn(keyword) -> create_meta_keyword_by_string(keyword) end)
              |> Enum.filter(& !is_nil(&1))

    case Blankable.blank?(results) do
      false -> results
      true -> nil
    end
  end

  def create_meta_keyword_by_string(keyword \\ "") do
    existing_keyword = get_meta_keyword_by_title(keyword)
    with {false, true} <- {Blankable.blank?(keyword), Blankable.blank?(existing_keyword)}
      do
      {:ok, new_keyword} = create_meta_keyword(%{"title"=>keyword})
      new_keyword |> Repo.preload(:posts)
    else
      _ -> existing_keyword
    end
  end

  def get_meta_keyword_by_title(title) do
    MetaKeyword |> Repo.get_by(title: title)
  end

  def meta_keyword_exists?(title) do
    meta_keyword = get_meta_keyword_by_title(title)
    cond do
      Blankable.blank?(meta_keyword) -> false
      true -> true
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
end
