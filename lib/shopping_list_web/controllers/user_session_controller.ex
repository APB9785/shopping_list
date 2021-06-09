defmodule ShoppingListWeb.UserSessionController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Accounts
  alias ShoppingListWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"name" => name, "password" => password} = user_params

    if user = Accounts.get_user_by_name_and_password(name, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid name or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
