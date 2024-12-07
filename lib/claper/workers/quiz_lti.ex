defmodule Claper.Workers.QuizLti do
  alias Claper.Quizzes.Quiz
  use Oban.Worker, queue: :default

  alias Lti13.Tool.Services.AGS

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"action" => "create", "quiz_id" => quiz_id}}) do
    with quiz <- Claper.Quizzes.get_quiz!(quiz_id),
         presentation_file <-
           Claper.Presentations.get_presentation_file!(quiz.presentation_file_id,
             event: [lti_resource: [:registration]]
           ),
         %Lti13.Resources.Resource{} = lti_resource <- presentation_file.event.lti_resource,
         {:ok, token} <- Lti13.Tool.Services.AccessToken.fetch_access_token(lti_resource) do
      case AGS.create_line_item(
             lti_resource.line_items_url,
             lti_resource.resource_id,
             100,
             quiz.title,
             token
           ) do
        {:ok, line_item} ->
          quiz
          |> Quiz.update_line_item_changeset(%{lti_line_item_url: line_item.id})
          |> Claper.Repo.update()

        {:error, error} ->
          {:error, error}
      end
    end
  end

  def perform(%Oban.Job{args: %{"action" => "update", "quiz_id" => quiz_id}}) do
    with quiz <- Claper.Quizzes.get_quiz!(quiz_id),
         presentation_file <-
           Claper.Presentations.get_presentation_file!(quiz.presentation_file_id,
             event: [lti_resource: [:registration]]
           ),
         %Lti13.Resources.Resource{} = lti_resource <- presentation_file.event.lti_resource,
         {:ok, token} <- Lti13.Tool.Services.AccessToken.fetch_access_token(lti_resource) do
      AGS.update_line_item(
        %AGS.LineItem{
          id: quiz.lti_line_item_url,
          label: quiz.title,
          scoreMaximum: 100,
          resourceId: lti_resource.resource_id
        },
        %{label: quiz.title},
        token
      )
    end
  end

  def edit(quiz_id) do
    new(%{
      "action" => "update",
      "quiz_id" => quiz_id
    })
  end

  def create(quiz_id) do
    new(%{
      "action" => "create",
      "quiz_id" => quiz_id
    })
  end
end
