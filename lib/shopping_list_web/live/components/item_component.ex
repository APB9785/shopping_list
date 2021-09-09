defmodule ShoppingListWeb.ItemComponent do
  @moduledoc false

  use ShoppingListWeb, :live_component

  alias ShoppingList.Accounts.User
  alias ShoppingList.Items
  alias ShoppingList.Items.Item

  def handle_event("toggle_item", _params, socket) do
    case socket.assigns.active_user do
      nil ->
        {:noreply, socket}

      %User{} ->
        item = socket.assigns.item
        {:ok, new_item} = Items.update_item(item, %{needed: !item.needed})
        message = {:update_one_category, new_item.category_id}
        Phoenix.PubSub.broadcast(ShoppingList.PubSub, "pubsub", message)

        {:noreply, socket}
    end
  end

  defp name_style(%Item{needed: true}), do: "cursor-pointer max-w-max"
  defp name_style(%Item{needed: false}), do: "cursor-pointer line-through max-w-max"
end
