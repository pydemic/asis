defmodule Asis.Repo.Migrations.CreateCovidRegistries do
  use Ecto.Migration

  def change do
    create table(:covid_registries, primary_key: false) do
      add :id, :string, primary_key: true

      add :date, :date
      add :is_positive, :boolean

      add :city_id, :integer
    end
  end
end
