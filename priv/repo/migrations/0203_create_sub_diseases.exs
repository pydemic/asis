defmodule Asis.Repo.Migrations.CreateSubDiseases do
  use Ecto.Migration

  def change do
    create table(:sub_diseases, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string

      add :disease_id, references(:diseases, on_delete: :delete_all, type: :string), null: false
    end
  end
end
