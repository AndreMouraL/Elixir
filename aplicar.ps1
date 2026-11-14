# Rode na RAIZ do projeto (D:\GitHub\Elixir\elixir_todo_list) depois de extrair o ZIP.
# Edita router, config, application, mix.exs e remove o teste antigo.
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Ler($p) { [IO.File]::ReadAllText((Join-Path (Get-Location) $p)) }
function Gravar($p, $t) { [IO.File]::WriteAllText((Join-Path (Get-Location) $p), $t, $utf8) }

# 1) router
$t = Ler "lib/elixir_todo_list_web/router.ex"
if ($t.Contains('get "/", PageController, :home')) {
  Gravar "lib/elixir_todo_list_web/router.ex" ($t.Replace('get "/", PageController, :home', 'live "/", TodoLive, :index'))
  Write-Host "OK router"
} else { Write-Host "AVISO: router ja alterado ou diferente" }

# 2) config.exs
$t = Ler "config/config.exs"
if (-not $t.Contains("ElixirTodoList.Repo")) {
  $bloco = "import Config`n`nconfig :elixir_todo_list, ElixirTodoList.Repo,`n  database: `"elixir_todo_list.db`",`n  priv: `"priv/repo`"`n`nconfig :elixir_todo_list, ecto_repos: [ElixirTodoList.Repo]"
  Gravar "config/config.exs" ($t.Replace("import Config", $bloco))
  Write-Host "OK config.exs"
} else { Write-Host "config.exs ja tem o Repo" }

# 3) test.exs
$t = Ler "config/test.exs"
if (-not $t.Contains("ElixirTodoList.Repo")) {
  $t += "`n`nconfig :elixir_todo_list, ElixirTodoList.Repo,`n  database: `"elixir_todo_list_test.db`",`n  pool: Ecto.Adapters.SQL.Sandbox,`n  pool_size: 1`n"
  Gravar "config/test.exs" $t
  Write-Host "OK test.exs"
} else { Write-Host "test.exs ja tem o Repo" }

# 4) application.ex
$t = Ler "lib/elixir_todo_list/application.ex"
if (-not $t.Contains("ElixirTodoList.Repo")) {
  Gravar "lib/elixir_todo_list/application.ex" ($t.Replace("children = [", "children = [`n      ElixirTodoList.Repo,"))
  Write-Host "OK application.ex"
} else { Write-Host "application.ex ja tem o Repo" }

# 5) mix.exs
$t = Ler "mix.exs"
if (-not $t.Contains("ecto_sqlite3")) {
  $deps = '{:ecto, "~> 3.11"},' + "`n      " + '{:phoenix_ecto, "~> 4.4"},' + "`n      " + '{:ecto_sql, "~> 3.10"},' + "`n      " + '{:ecto_sqlite3, "~> 0.12"},'
  $t = [regex]::Replace($t, '(\{:phoenix, "[^"]+"\},)', ('$1' + "`n      " + $deps), 1)
  $old = 'setup: ["deps.get", "assets.setup", "assets.build"],'
  if ($t.Contains($old)) {
    $new = 'setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],' + "`n      " + '"ecto.setup": ["ecto.create", "ecto.migrate"],' + "`n      " + '"ecto.reset": ["ecto.drop", "ecto.setup"],' + "`n      " + 'test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],'
    $t = $t.Replace($old, $new)
    Write-Host "OK mix.exs (deps + aliases)"
  } else { Write-Host "AVISO: alias setup diferente. Edite os aliases do mix.exs manualmente (veja LEIA-ME.md)" }
  Gravar "mix.exs" $t
} else { Write-Host "mix.exs ja tem o Ecto" }

# 6) teste antigo
$old = "test/elixir_todo_list_web/controllers/page_controller_test.exs"
if (Test-Path $old) { Remove-Item $old; Write-Host "OK page_controller_test removido" }

Write-Host "`nAgora rode: mix deps.get ; mix ecto.create ; mix ecto.migrate ; mix test"
