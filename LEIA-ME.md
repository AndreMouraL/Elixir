# Como usar este ZIP

1. Extraia o ZIP DENTRO de D:\GitHub\Elixir\elixir_todo_list (junto com o esqueleto
   gerado por `mix phx.new . --no-ecto`), aceitando substituir arquivos.
   Isso substitui: README.md, test/test_helper.exs e test/support/conn_case.ex.
2. No PowerShell, na raiz do projeto:
       powershell -ExecutionPolicy Bypass -File .\aplicar.ps1
3. Depois (um por linha):
       mix deps.get
       mix ecto.create
       mix ecto.migrate
       mix test
       mix phx.server
4. Apague aplicar.ps1 e LEIA-ME.md antes do commit final (opcional).

Se o script avisar sobre o mix.exs, edite manualmente:
- em deps, acrescente: {:ecto, "~> 3.11"}, {:phoenix_ecto, "~> 4.4"},
  {:ecto_sql, "~> 3.10"}, {:ecto_sqlite3, "~> 0.12"}
- em aliases, use:
    setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
    "ecto.setup": ["ecto.create", "ecto.migrate"],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
  (mantenha os demais aliases gerados)
