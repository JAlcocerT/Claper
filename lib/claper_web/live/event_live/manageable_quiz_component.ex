defmodule ClaperWeb.EventLive.ManageableQuizComponent do
  use ClaperWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok,
     socket |> assign(current_question_idx: -1) |> assign_new(:current_question, fn -> nil end)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={"#{@id}"}
      class={"#{if @quiz.show_results, do: "opacity-100", else: "opacity-0"} h-full w-full flex flex-col justify-center bg-black bg-opacity-90 absolute z-30 left-1/2 top-1/2 transform -translate-y-1/2 -translate-x-1/2 p-10 transition-opacity"}
    >
      <div class="w-full md:w-1/2 mx-auto h-full">
        <p class={"#{if @iframe, do: "text-xl mb-12", else: "text-5xl mb-24"} text-white font-bold  text-center"}>
          <%= @quiz.title %>
        </p>

        <div
          :if={@current_question_idx == -1}
          class={"#{if @iframe, do: "space-y-5", else: "space-y-8"} flex flex-col text-white text-center"}
        >
          <p class="font-semibold text-2xl"><%= gettext("Average score") %>:</p>
          <p class="font-semibold text-7xl">
            <%= Claper.Quizzes.calculate_average_score(@quiz.id) %>/<%= length(@quiz.quiz_questions) %>
          </p>
          <button
            phx-target={@myself}
            phx-click="show_results"
            class="w-1/2 mx-auto px-3 py-2 text-white text-2xl font-semibold bg-primary-500 hover:bg-primary-600 rounded-md"
          >
            <%= gettext("Show results") %>
          </button>
        </div>

        <div
          :if={@current_question_idx >= 0}
          class={"#{if @iframe, do: "space-y-5", else: "space-y-8"} flex flex-col text-white text-center"}
        >
          <%= for {opt, _idx} <- Enum.with_index(Enum.at(@quiz.quiz_questions, @current_question_idx).quiz_question_opts) do %>
            <div class={"bg-gray-500 px-3 py-2 rounded-xl flex justify-between items-center relative text-white #{if opt.is_correct, do: "bg-green-600"} #{if not opt.is_correct, do: "bg-red-600"}"}>
              <div class="bg-gradient-to-r from-primary-500 to-secondary-500 h-full absolute left-0 transition-all rounded-l-3xl">
              </div>
              <div class="flex space-x-3 items-center z-10 text-left">
                <span class="flex-1 pr-2"><%= opt.content %></span>
              </div>
            </div>
          <% end %>

          <button
            :if={
              @current_question_idx > 0 &&
                @current_question_idx <= length(@quiz.quiz_questions) - 1
            }
            phx-click="prev-question"
            phx-target={@myself}
            class="px-3 py-2 text-white font-semibold mt-3 mb-4"
          >
            <%= gettext("Back") %>
          </button>

          <button
            :if={@current_question_idx <= length(@quiz.quiz_questions) - 1}
            phx-click="next-question"
            phx-target={@myself}
            class="px-3 py-2 text-white font-semibold mt-3 mb-4"
          >
            <%= gettext("Next") %>
          </button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("show_results", _params, socket) do
    {:noreply, socket |> assign(current_question_idx: 0)}
  end

  @impl true
  def handle_event("prev-question", _params, socket) do
    idx =
      if socket.assigns.current_question_idx > 0,
        do: socket.assigns.current_question_idx - 1,
        else: 0

    {:noreply, socket |> assign(current_question_idx: idx)}
  end

  @impl true
  def handle_event("next-question", _params, socket) do
    idx =
      if socket.assigns.current_question_idx < length(socket.assigns.quiz.quiz_questions) - 1,
        do: socket.assigns.current_question_idx + 1,
        else: -1

    {:noreply, socket |> assign(current_question_idx: idx)}
  end
end
