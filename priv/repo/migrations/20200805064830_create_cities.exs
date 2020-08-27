defmodule Asis.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :abbr, :string
      add :lat, :float
      add :lng, :float

      add :world_id, references(:worlds, on_delete: :delete_all), null: false
      add :continent_id, references(:continents, on_delete: :delete_all), null: false
      add :country_id, references(:countries, on_delete: :delete_all), null: false
      add :region_id, references(:regions, on_delete: :delete_all), null: false
      add :state_id, references(:states, on_delete: :delete_all), null: false
      add :mesoregion_id, references(:mesoregions, on_delete: :delete_all), null: false
      add :microregion_id, references(:microregions, on_delete: :delete_all), null: false
    end

    create index(:cities, [:world_id])
    create index(:cities, [:continent_id])
    create index(:cities, [:country_id])
    create index(:cities, [:region_id])
    create index(:cities, [:state_id])
    create index(:cities, [:mesoregion_id])
    create index(:cities, [:microregion_id])
  end
end
