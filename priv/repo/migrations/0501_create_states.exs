defmodule Asis.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :abbr, :string
      add :lat, :float
      add :lng, :float
      add :name, :string

      add :world_id, references(:worlds, on_delete: :delete_all), null: false
      add :continent_id, references(:continents, on_delete: :delete_all), null: false
      add :country_id, references(:countries, on_delete: :delete_all), null: false
      add :region_id, references(:regions, on_delete: :delete_all), null: false
    end
  end
end
