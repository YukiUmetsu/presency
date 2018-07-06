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