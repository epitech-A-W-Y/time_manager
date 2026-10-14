import Config

config :time_manager, TimeManager.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "time-manager-db",
  database: "time_manager_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :time_manager, TimeManagerWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  https: [
    ip: {0, 0, 0, 0},
    port: 4001,
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem"
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "RoRZhmrOUwvWIVq6SGejmQXWI7Pr9C6Iuj/BtENXh64bFjiVmElnG1xK/trro/eb",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:time_manager, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:time_manager, ~w(--watch)]}
  ]

config :time_manager, dev_routes: false
config :time_manager, :secure_cookies, false

config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
config :swoosh, :api_client, false
