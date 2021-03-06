defmodule Asis.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string

      add :chapter_id, references(:chapters, on_delete: :delete_all, type: :string), null: false
      add :parent_block_id, references(:blocks, on_delete: :nilify_all, type: :string)
    end
  end
end
