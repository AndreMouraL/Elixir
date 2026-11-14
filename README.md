# 📝 Todo List com Elixir + Phoenix LiveView

> 🎥 **Vídeo de apresentação:** [COLE_AQUI_O_LINK](COLE_AQUI_O_LINK)

Aplicação de lista de tarefas em tempo real, com persistência em SQLite e interface
em daisyUI, construída com o modelo de **estado no servidor** do Phoenix LiveView.
Trabalho da Unidade 3 (Programação Funcional: Clojure e Elixir).

## 👥 Integrantes

- [Nome completo do Aluno 1]
- [Nome completo do Aluno 2]

## 📚 Tutorial de referência

[Como Criar um App Todo List com Elixir e LiveView do Zero](https://lambdageo-edu.github.io/lambdageo-tutorials/elixir/)

## ✨ Funcionalidades

- Criar tarefas com validação (título obrigatório)
- Listar tarefas persistidas no banco
- Marcar e desmarcar como concluída
- Excluir tarefas (com confirmação)
- Contador de concluídas e mensagens de feedback (flash)
- Atualização instantânea via WebSocket, sem JavaScript manual

## 🛠️ Tecnologias

| Tecnologia | Uso |
| --- | --- |
| Elixir / Erlang OTP | Linguagem e VM (BEAM) |
| Phoenix 1.8 + LiveView | Framework web e UI reativa |
| Ecto + ecto_sqlite3 | Schema, changesets, migrations e acesso ao banco |
| SQLite | Banco de dados em arquivo |
| Tailwind CSS v4 + daisyUI | Estilização e componentes |

## 🧱 Arquitetura

```
lib/
├── elixir_todo_list/
│   ├── repo.ex            # Ecto.Repo (SQLite3)
│   └── task.ex            # Schema + changeset
└── elixir_todo_list_web/
    ├── live/todo_live.ex  # mount, handle_event, render
    └── router.ex          # live "/", TodoLive
```

- `mount/3`: carrega tarefas com `Repo.all/1` e cria o formulário com `to_form/1`
- `handle_event/3`: `save_task`, `toggle_complete` e `delete`
- `Task.changeset/2`: `cast` + `validate_required`

## ✅ Pré-requisitos

- Erlang/OTP 26+ e Elixir 1.17+
- Git
- Node.js (opcional; os assets usam esbuild e Tailwind standalone)

## 🚀 Como executar

```bash
git clone [URL_DO_REPOSITORIO]
cd elixir_todo_list
mix local.hex --force
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server
```

Acesse <http://localhost:4000>. Atalho: `mix setup` faz dependências, banco e assets.

## 🧪 Testes

```bash
mix test
```

## 🧠 Principais dificuldades

- [Ex.: nomes de módulo derivados do nome da pasta]
- [Ex.: formulários com `to_form/1` e o formato `%{"task" => ...}`]
- [Ex.: instalação do Elixir no Windows e configuração do PATH]
- [Ex.: Ecto com SQLite e arquivos `.db-wal` no `.gitignore`]

## 📄 Licença

Uso acadêmico.
