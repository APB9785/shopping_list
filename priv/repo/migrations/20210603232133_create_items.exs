defmodule ShoppingList.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :category_id, references(:categories, on_delete: :delete_all)
      add :name, :string
      add :added_by, :integer
      add :needed, :boolean

      timestamps()
    end
  end
end
