defmodule Asis.Repo.Migrations.CreateBirthRegistries do
  use Ecto.Migration

  def change do
    create table(:birth_registries) do
      add :year, :integer

      add :city_id, :integer
      add :home_city_id, :integer
    end
  end
end
