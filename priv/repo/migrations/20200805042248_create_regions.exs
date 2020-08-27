defmodule Asis.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :name, :string
      add :abbr, :string
      add :lat, :float
      add :lng, :float

      add :world_id, references(:worlds, on_delete: :delete_all), null: false
      add :continent_id, references(:continents, on_delete: :delete_all), null: false
      add :country_id, references(:countries, on_delete: :delete_all), null: false
    end

    create index(:regions, [:world_id])
    create index(:regions, [:continent_id])
    create index(:regions, [:country_id])
  end
end
