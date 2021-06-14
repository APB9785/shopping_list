# ShoppingList
![GitHub](https://img.shields.io/github/license/APB9785/shopping_list)
![GitHub last commit](https://img.shields.io/github/last-commit/APB9785/shopping_list)

## Features

- Simple, one-page interface
- Real-time updates on all devices
- Eight different color themes to choose from
- Minimize lists which are not immediately needed

## Installation

To start a local ShoppingList server:

  * Install dependencies with `mix deps.get`
  * Adjust account names/passwords in `/priv/repo/seeds.exs`
  * Create and migrate your database with `mix ecto.setup`
  * Register the seed accounts with `mix run priv/repo/seeds.exs`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from this machine, or `[server-machine-IP]:4000` from other machines on the local network.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

Once your server is deployed, you must enter an `IEx` shell and run the command `ShoppingList.Accounts.register_user(%{name: "my_name", password: "my_pass"})` (where my_name and my_pass are replaced with your own desired values) for each user to whom you would like to give access.  Do not run seeds.exs in production.
