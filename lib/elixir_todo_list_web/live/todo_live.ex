defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view

  alias ElixirTodoList.Repo
  alias ElixirTodoList.Task

  @impl true
  def mount(_params, _session, socket) do
    tasks = Repo.all(Task)
    form = to_form(Task.changeset(%Task{}, %{}))
    {:ok, assign(socket, tasks: tasks, form: form)}
  end

  @impl true
  def handle_event("save_task", %{"task" => task_params}, socket) do
    changeset = Task.changeset(%Task{}, task_params)

    socket_atualizado =
      case Repo.insert(changeset) do
        {:ok, _new_task} ->
          socket
          |> assign(:tasks, Repo.all(Task))
          |> assign(:form, to_form(Task.changeset(%Task{}, %{})))
          |> put_flash(:info, "Tarefa salva com sucesso!")

        {:error, failed_changeset} ->
          assign(socket, form: to_form(failed_changeset))
      end

    {:noreply, socket_atualizado}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Repo.get!(Task, id) |> Repo.delete()

    {:noreply,
     socket
     |> assign(:tasks, Repo.all(Task))
     |> put_flash(:info, "Tarefa excluída.")}
  end

  @impl true
  def handle_event("toggle_complete", %{"id" => id}, socket) do
    task = Repo.get!(Task, id)
    {:ok, _} = task |> Task.changeset(%{completed: !task.completed}) |> Repo.update()
    {:noreply, assign(socket, :tasks, Repo.all(Task))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-xl mx-auto mt-8">
        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <h1 class="card-title text-3xl justify-center">Minha Lista de Tarefas</h1>

            <.form for={@form} id="task-form" phx-submit="save_task" class="mt-4">
              <.input
                field={@form[:title]}
                type="text"
                label="Nova Tarefa"
                placeholder="O que precisa ser feito?"
              />
              <.button variant="primary" phx-disable-with="Salvando...">Adicionar Tarefa</.button>
            </.form>

            <div class="divider"></div>

            <p :if={@tasks == []} id="empty-state" class="text-center opacity-60">
              Nenhuma tarefa ainda. Adicione a primeira!
            </p>

            <ul id="task-list" class="space-y-2">
              <li
                :for={task <- @tasks}
                id={"task-#{task.id}"}
                class="flex items-center gap-3 p-3 rounded-box bg-base-200"
              >
                <input
                  type="checkbox"
                  class="checkbox checkbox-primary"
                  checked={task.completed}
                  phx-click="toggle_complete"
                  phx-value-id={task.id}
                />
                <span class={["flex-1", task.completed && "line-through opacity-50"]}>
                  {task.title}
                </span>
                <button
                  id={"delete-#{task.id}"}
                  class="btn btn-ghost btn-sm text-error"
                  phx-click="delete"
                  phx-value-id={task.id}
                  data-confirm="Excluir esta tarefa?"
                  aria-label="Excluir tarefa"
                >
                  <.icon name="hero-trash" class="size-5" />
                </button>
              </li>
            </ul>

            <div :if={@tasks != []} class="badge badge-outline mt-2 self-end">
              {Enum.count(@tasks, & &1.completed)} de {length(@tasks)} concluídas
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
