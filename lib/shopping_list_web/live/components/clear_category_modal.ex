defmodule ShoppingListWeb.ClearCategoryModal do
  @moduledoc """
  The modal which shows when a user tries to clear a list which still contains
  needed items.
  """

  use ShoppingListWeb, :live_component

  alias ShoppingList.{Categories, Items}
  alias ShoppingListWeb.StyleHelpers

  def mount(socket) do
    {:ok, assign(socket, changeset: Items.change_item(%Items.Item{}))}
  end

  # Transform the category_list into a keyword list for the selector but don't
  # save it because the full list is not needed
  def update(assigns, socket) do
    category_select =
      assigns.category_list
      |> Stream.map(&{&1.name, &1.id})
      |> Stream.map(fn {name, id} -> {shortener(name), id} end)
      |> Enum.reject(fn {_name, id} -> id == assigns.category.id end)

    {:ok,
     assign(socket,
       category_select: category_select,
       category: assigns.category,
       active_user: assigns.active_user
     )}
  end

  def handle_event("move_items", %{"item" => %{"category_id" => id}}, socket) do
    id = String.to_integer(id)
    Items.change_category(socket.assigns.category.id, id)
    Categories.delete_category(socket.assigns.category)
    Phoenix.PubSub.broadcast(ShoppingList.PubSub, "pubsub", {:update_lists})
    send(self(), {:close_clear_modal})

    {:noreply, socket}
  end

  def handle_event("confirm_delete", %{"id" => id}, socket) do
    id = String.to_integer(id)
    Categories.delete_category(socket.assigns.category)
    Phoenix.PubSub.broadcast(ShoppingList.PubSub, "pubsub", {:category_deleted, id})
    send(self(), {:close_clear_modal})

    {:noreply, socket}
  end

  defp button_style(user) do
    [
      StyleHelpers.category_header_bg(user),
      " px-3 rounded-lg max-w-max border border-black ",
      StyleHelpers.category_header_font(user)
    ]
  end

  defp select_style(user) do
    [
      StyleHelpers.form_border_color(user),
      " md:px-2 border border-gray-400 focus:outline-none mr-4 max-w-max rounded-md"
    ]
  end

  def shortener(text) do
    case String.slice(text, 0..18) do
      ^text -> text
      short -> [short, "..."]
    end
  end
end
