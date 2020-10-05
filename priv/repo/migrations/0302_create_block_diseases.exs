defmodule Asis.Repo.Migrations.CreateBlockDiseases do
  use Ecto.Migration

  def change do
    create table(:block_diseases) do
      add :block_id, references(:blocks, on_delete: :delete_all, type: :string), null: false
      add :disease_id, references(:diseases, on_delete: :delete_all, type: :string), null: false
    end
  end
end
