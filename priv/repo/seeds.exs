# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Presency.Repo.insert!(%Presency.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Presency.Repo
alias Presency.Administration
alias Presency.CMS
alias Presency.CMS.Category

admin_user = %{
  "display_name" => "Yuki Umetsu",
  "last_name" => "Umetsu",
  "first_name" => "Yuki",
  "email" => "yuuki.umetsu@gmail.com",
  "name" => "Yuki Umetsu",
  "phone" => "4056428465",
  "password" => "123456",
  "username" => "yukiumetsu"
}

Administration.create_admin_user(admin_user)

category = %{"title"=> "Elixir",
  "description"=> "blog posts about Elixir, a functional programming language"
}
{:ok, elixirCategory} = CMS.create_category(category)

category = %{
  "title"=> "Phoenix framework",
  "description"=> "blog posts about elixir phoenix framework",
  "parent_category_id"=> elixirCategory.id
}
{:ok, phoenixCategory} = CMS.create_category(category)

Ecto.build_assoc(elixirCategory, :children_categories, phoenixCategory)
|> Category.changeset(%{})

category = %{
  "title"=> "PHP",
  "description"=> "blog posts about PHP programming language"
}
CMS.create_category(category)
