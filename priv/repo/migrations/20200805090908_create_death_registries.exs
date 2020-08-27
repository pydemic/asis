defmodule Asis.Repo.Migrations.CreateDeathRegistries do
  use Ecto.Migration

  def change do
    create table(:death_registries) do
      add :disease_id, :string
      add :sub_disease_id, :string

      # Source
      add :numerodo, :integer
      add :idade, :integer
      add :codmunres, :integer
      add :causabas_o, :string
    end
  end
end
