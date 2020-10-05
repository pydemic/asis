defmodule Asis.Repo.Migrations.CreateWorlds do
  use Ecto.Migration

  def change do
    create table(:worlds) do
      add :name, :string
      add :abbr, :string
      add :lat, :float
      add :lng, :float
    end
  end
end
