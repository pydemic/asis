defmodule Asis.Repo.Migrations.CreateMorbidityRegistries do
  use Ecto.Migration

  def change do
    create table(:morbidity_registries) do
      add :year, :integer
      add :week, :integer

      add :age, :integer

      add :city_id, :integer

      add :disease_id, :string
      add :sub_disease_id, :string
    end
  end
end
