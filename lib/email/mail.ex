defmodule Presency.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: PresencyWeb.EmailView

  def signin_email(email, subject, link) do
    base_email()
    |> to(email)
    |> subject(subject)
    |> render("signin.html", link: link)
  end

  defp base_email do
    new_email()
    |> from("fromsystem@mydevsquad.com")
    |> put_html_layout({PresencyWeb.LayoutView, "email.html"})
  end
end
