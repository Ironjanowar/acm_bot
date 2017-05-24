# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :acm_bot, Acm.Upm,
  adapter: Ecto.Adapters.MySQL,
  database: "acm_upm",
  username: "root",
  password: "",
  hostname: "localhost"

config :acm_bot, ecto_repos: [Acm.Upm]

config :acm_bot,
  token: "TOKEN"
