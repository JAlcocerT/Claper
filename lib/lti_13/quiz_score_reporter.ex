defmodule Lti13.QuizScoreReporter do
  alias Lti13.Tool.Services.AGS
  alias Lti13.Tool.Services.AGS.Score
  alias Lti13.Tool.Services.AGS.LineItem
  alias Claper.Quizzes

  def report_quiz_score(%Quizzes.Quiz{} = quiz, user_id) do
    quiz =
      quiz
      |> Claper.Repo.preload(lti_resource: [:registration])

    user = Claper.Accounts.get_user!(user_id) |> Claper.Repo.preload(:lti_user)

    if quiz.lti_resource do
      # Calculate score as percentage of correct answers
      score = calculate_score(quiz, user_id)
      timestamp = get_timestamp()

      case Lti13.Tool.Services.AccessToken.fetch_access_token(quiz.lti_resource) do
        {:ok, access_token} ->
          line_item = %LineItem{
            id: quiz.lti_line_item_url,
            scoreMaximum: 100.0,
            label: quiz.title,
            resourceId: quiz.lti_resource.resource_id
          }

          post_score(line_item, user.lti_user, score, timestamp, access_token)

        {:error, msg} ->
          {:error, msg}
      end
    else
      {:error, "Quiz not linked to LTI resource"}
    end
  end

  defp calculate_score(quiz, user_id) do
    {correct_answers, total_questions} = Quizzes.calculate_user_score(user_id, quiz.id)

    correct_answers / total_questions * 100
  end

  defp get_timestamp do
    {:ok, dt} = DateTime.now("Etc/UTC")
    DateTime.to_iso8601(dt)
  end

  defp post_score(line_item, %Lti13.Users.User{sub: user_id}, score, timestamp, access_token) do
    AGS.post_score(
      %Score{
        scoreGiven: score,
        scoreMaximum: 100.0,
        activityProgress: "Completed",
        gradingProgress: "FullyGraded",
        userId: user_id,
        comment: "",
        timestamp: timestamp
      },
      line_item,
      access_token
    )
  end
end
