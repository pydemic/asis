defmodule Asis.Repo.Migrations.CreateDeathRegistries do
  use Ecto.Migration

  def change do
    create table(:death_registries) do
      add :year, :integer

      add :age, :integer

      add :city_id, :integer

      add :disease_id, :string
      add :sub_disease_id, :string
      add :chapter_id, :string
    end
  end
end
