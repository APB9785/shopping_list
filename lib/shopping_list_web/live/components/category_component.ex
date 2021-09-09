defmodule ShoppingListWeb.CategoryComponent do
  @moduledoc false

  use ShoppingListWeb, :live_component

  alias ShoppingList.Accounts.User
  alias ShoppingList.Items
  alias ShoppingList.Items.Item
  alias ShoppingListWeb.StyleHelpers

  def mount(socket) do
    {:ok, assign(socket, new_item: false, item_changeset: nil)}
  end

  def handle_event("new_item", _params, socket) do
    case socket.assigns.active_user do
      nil ->
        {:noreply, push_redirect(socket, to: "/users/log_in")}

      %User{} ->
        changeset = Items.change_item(%Item{})
        {:noreply, assign(socket, new_item: true, item_changeset: changeset)}
    end
  end

  def handle_event("save_item", %{"item" => params}, socket) do
    case socket.assigns.active_user do
      nil ->
        {:noreply, socket}

      %User{} = user ->
        {:ok, item} =
          params
          |> Map.merge(%{
            "added_by" => user.id,
            "category_id" => socket.assigns.category.id,
            "needed" => true
          })
          |> Items.create_item()

        message = {:new_item, socket.assigns.category.id, item}
        Phoenix.PubSub.broadcast(ShoppingList.PubSub, "pubsub", message)

        {:noreply, assign(socket, new_item: false, item_changeset: nil)}
    end
  end

  def handle_event("cancel_item", _params, socket) do
    {:noreply, assign(socket, new_item: false)}
  end

  def handle_event("clear_list", _params, socket) do
    send(self(), {:clear_list, socket.assigns.category})
    {:noreply, socket}
  end

  defp background_style(user) do
    ["p-2 rounded-lg w-11/12 ", StyleHelpers.category_bg(user)]
  end

  defp header_style(user) do
    [
      "border border-black rounded-lg font-bold flex justify-between pl-2 ",
      StyleHelpers.category_header_bg(user),
      " shadow-inner items-center ",
      StyleHelpers.category_header_font(user)
    ]
  end

  defp button_style(user) do
    [
      StyleHelpers.category_header_bg(user),
      " px-3 rounded-lg max-w-max border border-black whitespace-nowrap ",
      StyleHelpers.category_header_font(user)
    ]
  end

  defp input_style(user) do
    [
      "border border-gray-700 pl-1 focus:outline-none rounded-md ",
      StyleHelpers.form_border_color(user)
    ]
  end
end
