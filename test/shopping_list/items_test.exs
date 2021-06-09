defmodule ShoppingList.ItemsTest do
  use ShoppingList.DataCase

  import ShoppingList.AccountsFixtures

  alias ShoppingList.Items

  describe "items" do
    alias ShoppingList.Items.Item
    alias ShoppingList.Categories.Category

    @valid_attrs %{
      name: "some item name",
      needed: true
    }
    @invalid_attrs %{added_by: nil, needed: nil, category_id: nil, name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        @valid_attrs
        |> Map.merge(attrs)
        |> Items.create_item()

      item
    end

    setup do
      %{
        category: Repo.insert!(%Category{name: "test category"}),
        user: user_fixture()
      }
    end

    test "list_items/0 returns all items", %{category: category, user: user} do
      item = item_fixture(%{category_id: category.id, added_by: user.id})
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id", %{category: category, user: user} do
      item = item_fixture(%{category_id: category.id, added_by: user.id})
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item", %{category: category, user: user} do
      assert {:ok, %Item{} = item} =
               Items.create_item(%{
                 added_by: user.id,
                 needed: true,
                 category_id: category.id,
                 name: "new item"
               })

      assert item.added_by == user.id
      assert item.needed == true
      assert item.category_id == category.id
      assert item.name == "new item"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item", %{category: category, user: user} do
      item = item_fixture(%{category_id: category.id, added_by: user.id})

      assert {:ok, %Item{} = item} =
               Items.update_item(item, %{needed: false, name: "updated item"})

      assert item.needed == false
      assert item.name == "updated item"
    end

    test "update_item/2 with invalid data returns error changeset", %{
      category: category,
      user: user
    } do
      item = item_fixture(%{category_id: category.id, added_by: user.id})
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item", %{category: category, user: user} do
      item = item_fixture(%{category_id: category.id, added_by: user.id})
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset", %{category: category, user: user} do
      item = item_fixture(%{category_id: category.id, added_by: user.id})
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
