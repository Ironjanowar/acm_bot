defmodule Schemas.Group do
  use Ecto.Schema

  schema "groups" do
    field :telegram_id, :integer
    field :name, :string
    field :description, :string
    field :link, :string
  end
end
