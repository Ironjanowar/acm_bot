defmodule Acm.Upm.Migrations.Groups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :telegram_id, :integer
      add :name, :string
      add :description, :string
      add :link, :string
    end
  end
end
