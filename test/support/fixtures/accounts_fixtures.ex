defmodule ShoppingList.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShoppingList.Accounts` context.
  """

  def unique_user_name, do: "user#{System.unique_integer()}"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Map.merge(
      %{
        name: unique_user_name(),
        password: valid_user_password(),
        theme: "purple"
      },
      attrs
    )
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> ShoppingList.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
