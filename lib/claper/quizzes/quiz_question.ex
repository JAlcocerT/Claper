defmodule Claper.Quizzes.QuizQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz_questions" do
    field :content, :string
    field :type, :string, default: "qcm"

    belongs_to :quiz, Claper.Quizzes.Quiz
    has_many :quiz_question_opts, Claper.Quizzes.QuizQuestionOpt, preload_order: [asc: :id], on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(quiz_question, attrs) do
    quiz_question
    |> cast(attrs, [:content, :type])
    |> validate_required([:content, :type])
    |> cast_assoc(:quiz_question_opts, required: true, with: &Claper.Quizzes.QuizQuestionOpt.changeset/2,
      sort_param: :quiz_question_opts_order,
      drop_param: :quiz_question_opts_delete)
  end
end
