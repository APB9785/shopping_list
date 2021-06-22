defmodule ShoppingListWeb.PageLive do
  @moduledoc false

  use ShoppingListWeb, :live_view

  alias ShoppingList.{Accounts, Categories}
  alias ShoppingList.Accounts.User
  alias ShoppingList.Categories.Category
  alias ShoppingListWeb.StyleHelpers

  def mount(_params, session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(ShoppingList.PubSub, "pubsub")

    case Accounts.get_user_by_session_token(session["user_token"]) do
      nil ->
        {:ok, socket |> assign(active_user: nil) |> assign_defaults()}

      %User{} = user ->
        {:ok,
         socket
         |> assign(active_user: user, theme_changeset: Accounts.change_user_theme(user))
         |> assign_defaults()}
    end
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("new_category", _params, socket) do
    changeset = Categories.change_category(%Category{})
    {:noreply, assign(socket, add_category: true, category_changeset: changeset)}
  end

  def handle_event("save_category", %{"category" => params}, socket) do
    case Categories.create_category(params) do
      {:ok, %Category{} = category} ->
        category = Map.put(category, :items, [])
        Phoenix.PubSub.broadcast(ShoppingList.PubSub, "pubsub", {:category_added, category})
        {:noreply, assign(socket, add_category: false)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, category_changeset: changeset)}
    end
  end

  def handle_event("cancel_category", _params, socket) do
    {:noreply, assign(socket, add_category: false)}
  end

  def handle_event("cancel_delete", _params, socket) do
    {:noreply, assign(socket, clear_category: nil)}
  end

  def handle_event("change_theme", %{"user" => params}, socket) do
    socket.assigns.active_user
    |> Accounts.update_user_theme(params)
    |> elem(1)
    |> then(
      &assign(socket,
        active_user: &1,
        bg_color: StyleHelpers.background_color(&1),
        theme_changeset: Accounts.change_user_theme(&1)
      )
    )
    |> then(&push_patch(&1, to: Routes.live_path(&1, ShoppingListWeb.PageLive)))
    |> then(&{:noreply, &1})
  end

  def handle_event("confirm_delete", %{"id" => id}, socket) do
    id = String.to_integer(id)

    id |> Categories.get_category!() |> Categories.delete_category()

    Phoenix.PubSub.broadcast(ShoppingList.PubSub, "pubsub", {:category_deleted, id})
    send(self(), {:close_clear_modal})

    {:noreply, socket}
  end

  def handle_event("show_hide", %{"id" => id, "action" => action}, socket) do
    case action do
      "show" ->
        new_visible = socket.assigns.visible_categories ++ [String.to_integer(id)]
        {:noreply, assign(socket, visible_categories: new_visible)}

      "hide" ->
        new_visible = socket.assigns.visible_categories -- [String.to_integer(id)]
        {:noreply, assign(socket, visible_categories: new_visible)}
    end
  end

  def handle_info({:category_added, category}, socket) do
    {:noreply,
     assign(socket,
       category_list: socket.assigns.category_list ++ [category],
       visible_categories: [category.id | socket.assigns.visible_categories]
     )}
  end

  def handle_info({:category_deleted, category_id}, socket) do
    {:noreply,
     assign(socket,
       category_list: Enum.reject(socket.assigns.category_list, &(&1.id == category_id)),
       visible_categories: socket.assigns.visible_categories -- [category_id]
     )}
  end

  def handle_info({:update_lists}, socket) do
    {:noreply, assign(socket, category_list: Categories.list_categories())}
  end

  def handle_info({:update_one_category, id}, socket) when is_integer(id) do
    Categories.get_category!(id)
    |> then(
      &Enum.map(socket.assigns.category_list, fn category ->
        if category.id == id, do: &1, else: category
      end)
    )
    |> then(&assign(socket, category_list: &1))
    |> then(&{:noreply, &1})
  end

  def handle_info({:new_item, category_id, item}, socket) when is_integer(category_id) do
    new_category_list =
      Enum.map(socket.assigns.category_list, fn category ->
        if category.id == category_id do
          Map.update!(category, :items, fn item_list -> item_list ++ [item] end)
        else
          category
        end
      end)

    {:noreply, assign(socket, category_list: new_category_list)}
  end

  def handle_info({:clear_list, category}, socket) do
    case Enum.filter(category.items, fn item -> item.needed end) do
      needed_items when needed_items == [] ->
        {:noreply, assign(socket, clear_category: {:empty, category.id})}

      _needed_items ->
        {:noreply, assign(socket, clear_category: category)}
    end
  end

  def handle_info({:close_clear_modal}, socket) do
    {:noreply, assign(socket, clear_category: nil)}
  end

  defp assign_defaults(socket) do
    category_list = Categories.list_categories()

    assign(socket,
      bg_color: StyleHelpers.background_color(socket.assigns.active_user),
      add_category: false,
      category_changeset: nil,
      category_list: category_list,
      visible_categories: Enum.map(category_list, fn category -> category.id end),
      clear_category: nil
    )
  end

  defp category_button(user) do
    [
      "px-3 py-1 mt-3 rounded-lg cursor-pointer max-w-max border border-black ",
      StyleHelpers.category_header_bg(user),
      " focus:outline-none ",
      StyleHelpers.category_header_font(user)
    ]
  end

  defp change_theme_button(user) do
    [
      "px-3 md:ml-4 rounded-lg max-w-max border border-black focus:outline-none ",
      StyleHelpers.category_header_bg(user),
      " focus:ring focus:ring-gray-400 text-sm md:text-base ",
      StyleHelpers.category_header_font(user)
    ]
  end

  defp text_input_style(user) do
    [
      StyleHelpers.category_header_bg(user),
      " border border-black pl-2 focus:outline-none rounded-lg font-bold ",
      StyleHelpers.category_header_font(user),
      " shadow-inner w-11/12 ",
      StyleHelpers.category_ring_border(user)
    ]
  end

  defp select_style(user) do
    [
      StyleHelpers.form_border_color(user),
      " md:px-2 border border-gray-400 focus:outline-none mr-4 max-w-max rounded-md"
    ]
  end

  defp theme_list, do: ["gray", "red", "yellow", "green", "blue", "indigo", "purple", "pink"]
end
