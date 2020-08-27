defmodule Asis.Repo.Migrations.CreateChapters do
  use Ecto.Migration

  def change do
    create table(:chapters, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :code_start, :string
      add :code_end, :string
    end
  end
end
