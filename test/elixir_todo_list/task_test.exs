defmodule ElixirTodoList.TaskTest do
  use ElixirTodoList.DataCase

  alias ElixirTodoList.Task

  test "changeset válido com título" do
    assert Task.changeset(%Task{}, %{title: "Estudar"}).valid?
  end

  test "changeset inválido sem título" do
    cs = Task.changeset(%Task{}, %{})
    refute cs.valid?
    assert %{title: ["can't be blank"]} = errors_on(cs)
  end

  test "insere e lista tarefas" do
    assert {:ok, %Task{completed: false}} =
             %Task{} |> Task.changeset(%{title: "Testar"}) |> Repo.insert()

    assert [%Task{title: "Testar"}] = Repo.all(Task)
  end

  test "não persiste tarefa inválida" do
    assert {:error, _} = %Task{} |> Task.changeset(%{}) |> Repo.insert()
    assert Repo.all(Task) == []
  end

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
