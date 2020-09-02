defmodule Asis.Repo.Migrations.CreateHealthRegions do
  use Ecto.Migration

  def change do
    create table(:health_regions) do
      add :name, :string
      add :abbr, :string
      add :lat, :float
      add :lng, :float

      add :world_id, references(:worlds, on_delete: :delete_all), null: false
      add :continent_id, references(:continents, on_delete: :delete_all), null: false
      add :country_id, references(:countries, on_delete: :delete_all), null: false
      add :region_id, references(:regions, on_delete: :delete_all), null: false
      add :state_id, references(:states, on_delete: :delete_all), null: false
    end

    create index(:health_regions, [:world_id])
    create index(:health_regions, [:continent_id])
    create index(:health_regions, [:country_id])
    create index(:health_regions, [:region_id])
    create index(:health_regions, [:state_id])
  end
end
