# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ShoppingList.Repo.insert!(%ShoppingList.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%{name: "tester", password: "localtest", theme: "purple"}
|> ShoppingList.Accounts.register_user()

%{name: "tester2", password: "localtest", theme: "red"}
|> ShoppingList.Accounts.register_user()
