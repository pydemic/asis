defmodule Asis.Repo.Migrations.CreatePentaYearCoverages do
  use Ecto.Migration

  def change do
    create table(:penta_year_coverages) do
      add :total, :integer
      add :year, :integer

      add :city_id, references(:cities, on_delete: :delete_all), null: false
    end
  end
end
