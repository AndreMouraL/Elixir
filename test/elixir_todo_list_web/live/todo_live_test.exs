defmodule ElixirTodoListWeb.TodoLiveTest do
  use ElixirTodoListWeb.ConnCase
  import Phoenix.LiveViewTest

  alias ElixirTodoList.{Repo, Task}

  test "lista tarefas já existentes no banco", %{conn: conn} do
    Repo.insert!(%Task{title: "Já no banco"})
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "Já no banco"
  end

  test "cria tarefa e persiste no banco", %{conn: conn} do
    {:ok, view, _} = live(conn, "/")

    view |> form("#task-form", task: %{title: "Comprar pão"}) |> render_submit()

    assert has_element?(view, "#task-list", "Comprar pão")
    assert [%Task{title: "Comprar pão"}] = Repo.all(Task)
    assert render(view) =~ "Tarefa salva com sucesso!"
  end

  test "mostra erro de validação com título em branco", %{conn: conn} do
    {:ok, view, _} = live(conn, "/")
    html = render_submit(view, "save_task", %{"task" => %{"title" => ""}})
    assert html =~ "blank"
    assert Repo.all(Task) == []
  end

  test "exclui uma tarefa", %{conn: conn} do
    task = Repo.insert!(%Task{title: "Apagar-me"})
    {:ok, view, _} = live(conn, "/")

    view |> element("#delete-#{task.id}") |> render_click()

    refute has_element?(view, "#task-#{task.id}")
    assert Repo.all(Task) == []
  end

  test "alterna conclusão da tarefa", %{conn: conn} do
    task = Repo.insert!(%Task{title: "Alternar"})
    {:ok, view, _} = live(conn, "/")

    view |> element("#task-#{task.id} input[type=checkbox]") |> render_click()
    assert Repo.get!(Task, task.id).completed

    view |> element("#task-#{task.id} input[type=checkbox]") |> render_click()
    refute Repo.get!(Task, task.id).completed
  end

  test "mostra estado vazio", %{conn: conn} do
    {:ok, view, _} = live(conn, "/")
    assert has_element?(view, "#empty-state")
  end

  test "mostra contador de concluídas", %{conn: conn} do
    Repo.insert!(%Task{title: "A", completed: true})
    Repo.insert!(%Task{title: "B"})
    {:ok, view, _} = live(conn, "/")
    assert render(view) =~ "1 de 2 concluídas"
  end
end
