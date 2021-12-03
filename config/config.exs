import Config

config :logger, :console, format: "[$date $time] - $level - $message $metadata\n"

import_config("#{Mix.env()}.exs")
