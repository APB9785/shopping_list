defmodule ShoppingListWeb.UserMenuComponent do
  @moduledoc false

  use ShoppingListWeb, :live_component

  alias ShoppingListWeb.StyleHelpers

  def main_style(user) do
    [
      "max-w-max border border-gray-700 block justify-center mb-2 rounded-sm mt-2 ",
      StyleHelpers.user_menu_bg(user)
    ]
  end

  def active_user_style(user) do
    ["font-bold ", StyleHelpers.active_user_font(user)]
  end
end
