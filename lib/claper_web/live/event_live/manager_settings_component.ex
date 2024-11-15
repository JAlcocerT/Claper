defmodule ClaperWeb.EventLive.ManagerSettingsComponent do
  use ClaperWeb, :live_component

  def render(assigns) do
    assigns = assigns |> assign_new(:show_shortcut, fn -> true end)

    ~H"""
    <div class="grid grid-cols-1 @md:grid-cols-2 @md:space-x-5 px-5 py-3">
      <div>
        <div class="flex items-center space-x-2 font-semibold text-lg">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5"
          >
            <path d="M6.111 11.89A5.5 5.5 0 1 1 15.501 8 .75.75 0 0 0 17 8a7 7 0 1 0-11.95 4.95.75.75 0 0 0 1.06-1.06Z" />
            <path d="M8.232 6.232a2.5 2.5 0 0 0 0 3.536.75.75 0 1 1-1.06 1.06A4 4 0 1 1 14 8a.75.75 0 0 1-1.5 0 2.5 2.5 0 0 0-4.268-1.768Z" />
            <path d="M10.766 7.51a.75.75 0 0 0-1.37.365l-.492 6.861a.75.75 0 0 0 1.204.65l1.043-.799.985 3.678a.75.75 0 0 0 1.45-.388l-.978-3.646 1.292.204a.75.75 0 0 0 .74-1.16l-3.874-5.764Z" />
          </svg>

          <span><%= gettext("Interaction") %></span>
        </div>

        <%= case @current_interaction do %>
          <% %Claper.Polls.Poll{} -> %>
            <div class="flex space-x-2 items-center mt-3">
              <ClaperWeb.Component.Input.check_button
                key={:poll_visible}
                checked={@state.poll_visible}
                shortcut={if @create == nil, do: "Z", else: nil}
              >
                <svg
                  :if={@state.poll_visible}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4h1m4 0h13" /><path d="M4 4v10a2 2 0 0 0 2 2h10m3.42 -.592c.359 -.362 .58 -.859 .58 -1.408v-10" /><path d="M12 16v4" /><path d="M9 20h6" /><path d="M8 12l2 -2m4 0l2 -2" /><path d="M3 3l18 18" />
                </svg>

                <svg
                  :if={!@state.poll_visible}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4l18 0" /><path d="M4 4v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2 -2v-10" /><path d="M12 16l0 4" /><path d="M9 20l6 0" /><path d="M8 12l3 -3l2 2l3 -3" />
                </svg>

                <span :if={@state.poll_visible}>
                  <%= gettext("Hide results on presentation") %>
                </span>
                <span :if={!@state.poll_visible}>
                  <%= gettext("Show results on presentation") %>
                </span>
                <code class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg">
                  z
                </code>
              </ClaperWeb.Component.Input.check_button>
            </div>
          <% %Claper.Quizzes.Quiz{} -> %>
            <div class="grid grid-cols-1 space-y-2 items-center mt-3">
              <ClaperWeb.Component.Input.check_button
                key={:quiz_show_results}
                checked={@current_interaction.show_results}
                shortcut={if @create == nil, do: "Z", else: nil}
              >
                <svg
                  :if={@current_interaction.show_results}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4h1m4 0h13" /><path d="M4 4v10a2 2 0 0 0 2 2h10m3.42 -.592c.359 -.362 .58 -.859 .58 -1.408v-10" /><path d="M12 16v4" /><path d="M9 20h6" /><path d="M8 12l2 -2m4 0l2 -2" /><path d="M3 3l18 18" />
                </svg>

                <svg
                  :if={!@current_interaction.show_results}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4l18 0" /><path d="M4 4v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2 -2v-10" /><path d="M12 16l0 4" /><path d="M9 20l6 0" /><path d="M8 12l3 -3l2 2l3 -3" />
                </svg>

                <span :if={@current_interaction.show_results}>
                  <%= gettext("Hide results on presentation") %>
                </span>
                <span :if={!@current_interaction.show_results}>
                  <%= gettext("Show results on presentation") %>
                </span>
                <code class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg">
                  z
                </code>
              </ClaperWeb.Component.Input.check_button>
              <div>
                <ClaperWeb.Component.Input.check_button
                  disabled={!@current_interaction.show_results}
                  key={:review_quiz_questions}
                  checked={true}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    class="w-6 h-6"
                  >
                    <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 13a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v6a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" /><path d="M15 9a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v10a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" /><path d="M9 5a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v14a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" /><path d="M4 20h14" />
                  </svg>

                  <span>
                    <%= gettext("Review results") %>
                  </span>
                </ClaperWeb.Component.Input.check_button>
              </div>
              <div class="grid grid-cols-2 gap-2">
                <ClaperWeb.Component.Input.check_button
                  disabled={!@current_interaction.show_results}
                  key={:prev_quiz_question}
                  checked={true}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    class="w-6 h-6"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z"
                      clip-rule="evenodd"
                    />
                  </svg>

                  <span>
                    <%= gettext("Previous question") %>
                  </span>
                </ClaperWeb.Component.Input.check_button>
                <ClaperWeb.Component.Input.check_button
                  disabled={!@current_interaction.show_results}
                  key={:next_quiz_question}
                  checked={true}
                >
                  <span>
                    <%= gettext("Next question") %>
                  </span>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    class="w-6 h-6"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </ClaperWeb.Component.Input.check_button>
              </div>
            </div>
          <% nil -> %>
            <p class="text-gray-400 italic mt-2">No interaction enabled</p>
          <% _ -> %>
            <p class="text-gray-400 italic mt-2">No settings available for this interaction</p>
        <% end %>

        <div class="flex space-x-2 items-center mt-3"></div>
      </div>
      <div class="grid grid-cols-1 space-y-5">
        <div>
          <div class="flex items-center space-x-2 font-semibold text-lg">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-5 h-5"
            >
              <path
                fill-rule="evenodd"
                d="M1 2.75A.75.75 0 0 1 1.75 2h16.5a.75.75 0 0 1 0 1.5H18v8.75A2.75 2.75 0 0 1 15.25 15h-1.072l.798 3.06a.75.75 0 0 1-1.452.38L13.41 18H6.59l-.114.44a.75.75 0 0 1-1.452-.38L5.823 15H4.75A2.75 2.75 0 0 1 2 12.25V3.5h-.25A.75.75 0 0 1 1 2.75ZM7.373 15l-.391 1.5h6.037l-.392-1.5H7.373ZM13.25 5a.75.75 0 0 1 .75.75v5.5a.75.75 0 0 1-1.5 0v-5.5a.75.75 0 0 1 .75-.75Zm-6.5 4a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-1.5 0v-1.5A.75.75 0 0 1 6.75 9Zm4-1.25a.75.75 0 0 0-1.5 0v3.5a.75.75 0 0 0 1.5 0v-3.5Z"
                clip-rule="evenodd"
              />
            </svg>

            <span><%= gettext("Presentation") %></span>
          </div>

          <div class="flex space-x-2 items-center mt-3">
            <ClaperWeb.Component.Input.check
              key={:join_screen_visible}
              checked={@state.join_screen_visible}
              shortcut={if @create == nil, do: "Q", else: nil}
            />
            <span>
              <%= gettext("Show instructions (QR Code)") %>
              <code
                :if={@show_shortcut}
                class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
              >
                q
              </code>
            </span>
          </div>

          <div class="flex space-x-2 items-center mt-3">
            <ClaperWeb.Component.Input.check
              key={:chat_visible}
              checked={@state.chat_visible}
              shortcut={if @create == nil, do: "W", else: nil}
            />
            <span>
              <%= gettext("Show messages") %>
              <code
                :if={@show_shortcut}
                class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
              >
                w
              </code>
            </span>
          </div>

          <div
            class={"#{if !@state.chat_visible, do: "opacity-50"} flex space-x-2 items-center mt-3"}
            title={
              if !@state.chat_visible,
                do: gettext("Show messages to change this option"),
                else: nil
            }
          >
            <ClaperWeb.Component.Input.check
              key={:show_only_pinned}
              checked={@state.show_only_pinned}
              disabled={!@state.chat_visible}
              shortcut={if @create == nil, do: "E", else: nil}
            />
            <span>
              <%= gettext("Show only pinned messages") %>
              <code
                :if={@show_shortcut}
                class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
              >
                e
              </code>
            </span>
          </div>
        </div>

        <div>
          <div class="flex items-center space-x-2 font-semibold text-lg">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="w-5 h-5"
            >
              <path d="M8 16.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z" />
              <path
                fill-rule="evenodd"
                d="M4 4a3 3 0 0 1 3-3h6a3 3 0 0 1 3 3v12a3 3 0 0 1-3 3H7a3 3 0 0 1-3-3V4Zm4-1.5v.75c0 .414.336.75.75.75h2.5a.75.75 0 0 0 .75-.75V2.5h1A1.5 1.5 0 0 1 14.5 4v12a1.5 1.5 0 0 1-1.5 1.5H7A1.5 1.5 0 0 1 5.5 16V4A1.5 1.5 0 0 1 7 2.5h1Z"
                clip-rule="evenodd"
              />
            </svg>

            <span><%= gettext("Attendees") %></span>
          </div>

          <div class="flex space-x-2 items-center mt-3">
            <ClaperWeb.Component.Input.check
              key={:chat_enabled}
              checked={@state.chat_enabled}
              shortcut={if @create == nil, do: "A", else: nil}
            />
            <span>
              <%= gettext("Enable messages") %>
              <code
                :if={@show_shortcut}
                class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
              >
                a
              </code>
            </span>
          </div>

          <div
            class={"#{if !@state.chat_enabled, do: "opacity-50"} flex space-x-2 items-center mt-3"}
            title={
              if !@state.chat_enabled,
                do: gettext("Enable messages to change this option"),
                else: nil
            }
          >
            <ClaperWeb.Component.Input.check
              key={:anonymous_chat_enabled}
              checked={@state.anonymous_chat_enabled}
              disabled={!@state.chat_enabled}
              shortcut={if @create == nil, do: "S", else: nil}
            />
            <span>
              <%= gettext("Enable anonymous messages") %>
              <code
                :if={@show_shortcut}
                class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
              >
                s
              </code>
            </span>
          </div>

          <div class="flex space-x-2 items-center mt-3">
            <ClaperWeb.Component.Input.check
              key={:message_reaction_enabled}
              checked={@state.message_reaction_enabled}
              shortcut={if @create == nil, do: "D", else: nil}
            />
            <span>
              <%= gettext("Enable reactions") %>
              <code
                :if={@show_shortcut}
                class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
              >
                d
              </code>
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
