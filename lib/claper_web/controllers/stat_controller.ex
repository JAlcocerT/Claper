defmodule ClaperWeb.StatController do
  @moduledoc """
  Controller responsible for exporting various statistics and data in CSV format.
  Handles form submissions, messages, and poll results exports.
  """
  use ClaperWeb, :controller

  alias Claper.{Forms, Events, Polls, Presentations, Quizzes}

  @doc """
  Exports form submissions as a CSV file.
  """
  def export_form(conn, %{"form_id" => form_id}) do
    form = Forms.get_form!(form_id, [:form_submits])
    headers = form.fields |> Enum.map(& &1.name)

    data =
      form.form_submits
      |> Enum.map(fn submit ->
        form.fields
        |> Enum.map(fn field ->
          Map.get(submit.response, field.name, "")
        end)
      end)

    export_as_csv(conn, headers, data, "form-#{sanitize(form.title)}")
  end

  @doc """
  Exports all messages from an event as a CSV file.
  Requires user to be either an event leader or the event owner.
  """
  def export_all_messages(%{assigns: %{current_user: current_user}} = conn, %{
        "event_id" => event_id
      }) do
    event = Events.get_event!(event_id, posts: [:user])

    case authorize_event_access(current_user, event) do
      :ok ->
        headers = [
          "Attendee identifier",
          "User email",
          "Name",
          "Message",
          "Pinned",
          "Slide #",
          "Sent at (UTC)"
        ]

        content = format_messages_for_export(event.posts)

        export_as_csv(conn, headers, content, "messages-#{sanitize(event.name)}")

      :unauthorized ->
        send_resp(conn, 403, "Forbidden")
    end
  end

  @doc """
  Exports poll results as a CSV file.
  Requires user to be either an event leader or the event owner.
  """
  def export_poll(%{assigns: %{current_user: current_user}} = conn, %{"poll_id" => poll_id}) do
    with poll <- Polls.get_poll!(poll_id),
         presentation_file <-
           Presentations.get_presentation_file!(poll.presentation_file_id, [:event]),
         event <- presentation_file.event,
         :ok <- authorize_event_access(current_user, event) do
      headers = ["Name", "Multiple choice", "Slide #"] ++ Enum.map(poll.poll_opts, & &1.content)

      content =
        [poll.title, poll.multiple, poll.position + 1] ++
          Enum.map(poll.poll_opts, & &1.vote_count)

      export_as_csv(conn, headers, [content], "poll-#{sanitize(poll.title)}")
    else
      :unauthorized -> send_resp(conn, 403, "Forbidden")
    end
  end

  @doc """
  Exports quiz results as a CSV file.
  Requires user to be either an event leader or the event owner.
  """
  def export_quiz(%{assigns: %{current_user: current_user}} = conn, %{"quiz_id" => quiz_id}) do
    with quiz <-
           Quizzes.get_quiz!(quiz_id, [
             :quiz_questions,
             quiz_questions: :quiz_question_opts,
             presentation_file: :event
           ]),
         event <- quiz.presentation_file.event,
         :ok <- authorize_event_access(current_user, event) do
      # Create headers for the CSV
      headers = ["Question", "Correct Answers", "Total Responses", "Response Distribution (%)"]

      # Format data rows
      data =
        quiz.quiz_questions
        |> Enum.map(fn question ->
          [
            question.content,
            # Correct answers
            question.quiz_question_opts
            |> Enum.filter(& &1.is_correct)
            |> Enum.map_join(", ", & &1.content),
            # Total responses
            question.quiz_question_opts
            |> Enum.map(& &1.response_count)
            |> Enum.sum()
            |> to_string(),
            # Response distribution
            question.quiz_question_opts
            |> Enum.map_join(", ", fn opt ->
              "#{opt.content}: #{opt.percentage}%"
            end)
          ]
        end)

      export_as_csv(conn, headers, data, "quiz-#{sanitize(quiz.title)}")
    else
      :unauthorized -> send_resp(conn, 403, "Forbidden")
    end
  end

  # Private functions

  defp authorize_event_access(user, event) do
    if Events.leaded_by?(user.email, event) || event.user_id == user.id do
      :ok
    else
      :unauthorized
    end
  end

  defp format_messages_for_export(posts) do
    posts
    |> Enum.map(fn post ->
      [
        format_attendee_identifier(post.attendee_identifier),
        format_user_email(post.user),
        post.name || "N/A",
        post.body,
        post.pinned,
        post.position + 1,
        post.inserted_at
      ]
    end)
  end

  defp format_attendee_identifier(nil), do: "N/A"
  defp format_attendee_identifier(identifier), do: Base.encode16(identifier)

  defp format_user_email(nil), do: "N/A"
  defp format_user_email(user), do: user.email

  defp export_as_csv(conn, headers, data, filename) do
    csv_data =
      ([headers] ++ data)
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, csv_data)
  end

  defp sanitize(string),
    do: string |> String.replace(~r/[^\w\s-]/, "") |> String.replace(~r/\s+/, "-")
end
