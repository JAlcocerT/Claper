defmodule ClaperWeb.StatController do
  use ClaperWeb, :controller

  alias Claper.Forms

  def export_form(conn, %{"form_id" => form_id}) do
    form = Forms.get_form!(form_id, [:form_submits])
    headers = form.fields |> Enum.map(& &1.name)
    csv_data = headers |> csv_content(form.form_submits |> Enum.map(& &1.response))

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"form-#{sanitize(form.title)}.csv\""
    )
    |> put_root_layout(false)
    |> send_resp(200, csv_data)
  end

  def export_all_messages(%{assigns: %{current_user: current_user}} = conn, %{
        "event_id" => event_id
      }) do
    event = Claper.Events.get_event!(event_id, posts: [:user])

    if Claper.Events.leaded_by?(current_user.email, event) || event.user_id == current_user.id do
      headers = [
        "Attendee identifier",
        "User email",
        "Name",
        "Message",
        "Pinned",
        "Slide #",
        "Sent at (UTC)"
      ]

      content =
        event.posts
        |> Enum.map(
          &[
            if(&1.attendee_identifier, do: &1.attendee_identifier |> Base.encode16(), else: "N/A"),
            if(&1.user, do: &1.user.email, else: "N/A"),
            &1.name || "N/A",
            &1.body,
            &1.pinned,
            &1.position + 1,
            &1.inserted_at
          ]
        )

      csv_data = ([headers] ++ content) |> CSV.encode() |> Enum.to_list() |> to_string

      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=\"messages-#{sanitize(event.name)}.csv\""
      )
      |> put_root_layout(false)
      |> send_resp(200, csv_data)
    else
      conn
      |> send_resp(403, "Forbidden")
    end
  end

  def export_poll(%{assigns: %{current_user: current_user}} = conn, %{
        "poll_id" => poll_id
      }) do
    poll = Claper.Polls.get_poll!(poll_id)

    presentation_file =
      Claper.Presentations.get_presentation_file!(poll.presentation_file_id, [:event])

    event = presentation_file.event

    if Claper.Events.leaded_by?(current_user.email, event) || event.user_id == current_user.id do
      headers =
        [
          "Name",
          "Multiple choice",
          "Slide #"
        ] ++
          Enum.map(poll.poll_opts, & &1.content)

      content =
        [poll.title, poll.multiple, poll.position + 1] ++
          Enum.map(poll.poll_opts, & &1.vote_count)

      csv_data = ([headers] ++ [content]) |> CSV.encode() |> Enum.to_list() |> to_string

      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=\"poll-#{sanitize(poll.title)}.csv\""
      )
      |> put_root_layout(false)
      |> send_resp(200, csv_data)
    else
      conn
      |> send_resp(403, "Forbidden")
    end
  end

  defp csv_content(headers, records) do
    data =
      records
      |> Enum.map(&(&1 |> Map.values()))

    ([headers] ++ data)
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end

  defp sanitize(string) do
    string |> String.downcase() |> String.replace(" ", "_") |> String.trim()
  end
end
