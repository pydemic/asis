defmodule Asis.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string
      add :abbr, :string
      add :lat, :float
      add :lng, :float

      add :world_id, references(:worlds, on_delete: :delete_all), null: false
      add :continent_id, references(:continents, on_delete: :delete_all), null: false
    end

    create index(:countries, [:world_id])
    create index(:countries, [:continent_id])
  end
end
