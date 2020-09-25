defmodule Asis.Repo.Migrations.CreateMorbidityRegistries do
  use Ecto.Migration

  def change do
    create table(:morbidity_registries) do
      add :disease_id, :string
      add :sub_disease_id, :string
      add :year, :integer

      # Source
      add :nu_notific, :integer
      add :id_agravo, :string
      add :id_municip, :integer
      add :nu_idade_n, :integer
    end
  end
end
