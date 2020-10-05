defmodule Asis.Repo.Migrations.CreateDiseases do
  use Ecto.Migration

  def change do
    create table(:diseases, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
    end
  end
end
