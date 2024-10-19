defmodule Claper.Quizzes do
  import Ecto.Query, warn: false
  alias Claper.Repo

  alias Claper.Quizzes.Quiz
  alias Claper.Quizzes.QuizQuestion
  alias Claper.Quizzes.QuizQuestionOpt
  alias Claper.Quizzes.QuizResponse

  @doc """
  Returns the list of quizzes for a given presentation file.

  ## Examples

      iex> list_quizzes(123)
      [%Quiz{}, ...]

  """
  def list_quizzes(presentation_file_id) do
    from(p in Quiz,
      where: p.presentation_file_id == ^presentation_file_id,
      order_by: [asc: p.id, asc: p.position]
    )
    |> Repo.all()
    |> Repo.preload([:quiz_questions, quiz_questions: :quiz_question_opts])
  end

  @doc """
  Returns the list of quizzes for a given presentation file and a given position.

  ## Examples

      iex> list_quizzes_at_position(123, 0)
      [%Quiz{}, ...]

  """
  def list_quizzes_at_position(presentation_file_id, position) do
    from(q in Quiz,
      where: q.presentation_file_id == ^presentation_file_id and q.position == ^position,
      order_by: [asc: q.id]
    )
    |> Repo.all()
    |> Repo.preload([:quiz_questions, quiz_questions: :quiz_question_opts])
  end



  @doc """
  Gets a single quiz by ID.

  Raises `Ecto.NoResultsError` if the Quiz does not exist.

  ## Parameters

    - id: The ID of the quiz.

  ## Examples

      iex> get_quiz!(123)
      %Quiz{}

      iex> get_quiz!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz!(id) do
    Quiz
    |> Repo.get!(id)
    |> Repo.preload([:quiz_questions, quiz_questions: :quiz_question_opts])
  end

  @doc """
  Creates a quiz.

  ## Parameters

    - attrs: A map of attributes for creating a quiz.

  ## Examples

      iex> create_quiz(%{field: value})
      {:ok, %Quiz{}}

      iex> create_quiz(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz(attrs \\ %{}) do
    %Quiz{}
    |> Quiz.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz.

  ## Parameters

    - quiz: The quiz struct to update.
    - attrs: A map of attributes to update.

  ## Examples

      iex> update_quiz(quiz, %{field: new_value})
      {:ok, %Quiz{}}

      iex> update_quiz(quiz, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz(event_uuid, %Quiz{} = quiz, attrs) do
    quiz
    |> Quiz.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, quiz} ->
        broadcast({:ok, quiz, event_uuid}, :quiz_updated)

      {:error, changeset} ->
        {:error, %{changeset | action: :update}}
    end
  end

  @doc """
  Deletes a quiz.

  ## Parameters

    - event_uuid: The UUID of the event.
    - quiz: The quiz struct to delete.

  ## Examples

      iex> delete_quiz(event_uuid, quiz)
      {:ok, %Quiz{}}

      iex> delete_quiz(event_uuid, quiz)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz(event_uuid, %Quiz{} = quiz) do
    {:ok, quiz} = Repo.delete(quiz)
    broadcast({:ok, quiz, event_uuid}, :quiz_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz changes.

  ## Parameters

    - quiz: The quiz struct to create a changeset for.
    - attrs: A map of attributes (optional).

  ## Examples

      iex> change_quiz(quiz)
      %Ecto.Changeset{data: %Quiz{}}

  """
  def change_quiz(%Quiz{} = quiz, attrs \\ %{}) do
    Quiz.changeset(quiz, attrs)
  end

  def add_quiz_question(changeset) do
    existing_questions = Ecto.Changeset.get_change(changeset, :quiz_questions, [])

    new_question = %QuizQuestion{
      quiz_question_opts: [
        %QuizQuestionOpt{},
        %QuizQuestionOpt{}
      ]
    }

    new_question_changeset = Ecto.Changeset.change(new_question)

    updated_questions = existing_questions ++ [new_question_changeset]

    Ecto.Changeset.put_change(changeset, :quiz_questions, updated_questions)
  end

  def remove_quiz_question(changeset, index) do
    changeset
    |> Ecto.Changeset.update_change(:quiz_questions, fn questions ->
      List.delete_at(questions, index)
    end)
  end

  @doc """
  Add an empty quiz opt to a quiz changeset.
  """
  def add_quiz_question_opt(changeset, question_index) do
    update_quiz_question_at_index(changeset, question_index, fn question_changeset ->
      existing_opts = Ecto.Changeset.get_change(question_changeset, :quiz_question_opts, [])
      new_opt = %QuizQuestionOpt{}
      new_opt_changeset = Ecto.Changeset.change(new_opt)
      updated_opts = existing_opts ++ [new_opt_changeset]
      Ecto.Changeset.put_change(question_changeset, :quiz_question_opts, updated_opts)
    end)
  end

  @doc """
  Remove a quiz question opt from a quiz question changeset.
  """
  def remove_quiz_question_opt(changeset, question_index, opt_index) do
    update_quiz_question_at_index(changeset, question_index, fn question_changeset ->
      existing_opts = Ecto.Changeset.get_change(question_changeset, :quiz_question_opts, [])
      updated_opts = List.delete_at(existing_opts, opt_index)
      Ecto.Changeset.put_change(question_changeset, :quiz_question_opts, updated_opts)
    end)
  end

    # Helper function to update a specific quiz question
  defp update_quiz_question_at_index(changeset, index, update_fn) do
    Ecto.Changeset.update_change(changeset, :quiz_questions, fn questions ->
      List.update_at(questions, index, update_fn)
    end)
  end

  def disable_all(presentation_file_id, position) do
    from(q in Quiz,
      where: q.presentation_file_id == ^presentation_file_id and q.position == ^position
    )
    |> Repo.update_all(set: [enabled: false])
  end

  def set_enabled(id) do
    get_quiz!(id)
    |> Ecto.Changeset.change(enabled: true)
    |> Repo.update()
  end

  def set_disabled(id) do
    get_quiz!(id)
    |> Ecto.Changeset.change(enabled: false)
    |> Repo.update()
  end

  defp broadcast({:error, _reason} = error, _quiz), do: error

  defp broadcast({:ok, quiz, event_uuid}, event) do
    Phoenix.PubSub.broadcast(
      Claper.PubSub,
      "event:#{event_uuid}",
      {event, quiz}
    )

    {:ok, quiz}
  end
end
