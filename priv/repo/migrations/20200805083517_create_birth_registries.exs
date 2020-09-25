defmodule Asis.Repo.Migrations.CreateBirthRegistries do
  use Ecto.Migration

  def change do
    create table(:birth_registries) do
      add :year, :integer

      # Source
      add :numerodn, :integer
      add :codmunnasc, :integer
      add :codmunres, :integer
    end
  end
end
