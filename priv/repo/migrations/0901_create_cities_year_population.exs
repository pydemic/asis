defmodule Asis.Repo.Migrations.CreateCitiesYearPopulation do
  use Ecto.Migration

  def change do
    create table(:cities_year_population) do
      add :age_0_4, :integer
      add :age_5_9, :integer
      add :age_10_14, :integer
      add :age_15_19, :integer
      add :age_20_29, :integer
      add :age_30_39, :integer
      add :age_40_49, :integer
      add :age_50_59, :integer
      add :age_60_69, :integer
      add :age_70_79, :integer
      add :age_80_or_more, :integer

      add :female, :integer
      add :male, :integer

      add :total, :integer

      add :year, :integer

      add :city_id, references(:cities, on_delete: :delete_all), null: false
    end
  end
end
