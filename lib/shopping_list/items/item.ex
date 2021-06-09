defmodule ShoppingList.Items.Item do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :added_by, :integer
    field :needed, :boolean
    field :category_id, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:category_id, :name, :added_by, :needed])
    |> validate_required([:category_id, :name, :added_by, :needed])
  end
end
