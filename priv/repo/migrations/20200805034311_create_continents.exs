defmodule Asis.Repo.Migrations.CreateContinents do
  use Ecto.Migration

  def change do
    create table(:continents) do
      add :name, :string
      add :abbr, :string
      add :lat, :float
      add :lng, :float

      add :world_id, references(:worlds, on_delete: :delete_all), null: false
    end

    create index(:continents, [:world_id])
  end
end
