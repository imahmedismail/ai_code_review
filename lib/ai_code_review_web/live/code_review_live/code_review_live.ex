defmodule AiCodeReviewWeb.CodeReviewLive do
  use AiCodeReviewWeb, :live_view
  alias Tesla
  alias Jason

  def mount(_params, _session, socket) do
    {:ok, assign(socket, ai_response: nil, loading: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-6">
      <h1 class="text-2xl font-bold mb-4">AI Code Review Assistant</h1>

      <form phx-submit="submit_code">
        <textarea
          class="w-full p-2 border rounded mb-4"
          placeholder="Paste your code here..."
          name="code"
          rows="10"
        >
        </textarea>

        <button
          type="submit"
          class="bg-blue-500 text-white px-4 py-2 rounded"
          phx-disable-with="Analyzing..."
        >
          Analyze Code
        </button>
      </form>

      <%= if @loading do %>
        <div class="fixed inset-0 bg-gray-800 bg-opacity-50 flex justify-center items-center z-50">
          <div class="text-center text-white">
            <p class="mb-4 text-lg">Analyzing your provided snippet...</p>
            <div class="loader"></div>
          </div>
        </div>
      <% end %>

      <%= if @ai_response do %>
        <div class="mt-6 p-4 border rounded bg-gray-100">
          <h2 class="font-semibold">AI Suggestions:</h2>
          <pre class="whitespace-pre-wrap text-sm text-gray-800"><%= @ai_response %></pre>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("submit_code", %{"code" => code}, socket) do
    socket = assign(socket, loading: true)
    Task.async(fn -> analyze_code_with_deepseek(code, self()) end)
    {:noreply, socket}
  end

  defp analyze_code_with_deepseek(code, pid) do
    url = "http://localhost:11434/api/generate"

    body = %{
      "model" => "deepseek-r1",
      "prompt" => "Analyze this code and provide feedback: \n\n#{code}",
      "stream" => false
    }

    headers = [{"Content-Type", "application/json"}]

    case Tesla.post(url, Jason.encode!(body), headers: headers) do
      {:ok, %{status: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"response" => response}} ->
            send(pid, {:ai_response, response})

          _ ->
            send(
              pid,
              {:ai_response, "Error: Invalid response format from DeepSeek R1 on Ollama."}
            )
        end

      {:error, reason} ->
        send(
          pid,
          {:ai_response, "Error: Failed to connect to DeepSeek R1 on Ollama: #{inspect(reason)}"}
        )
    end
  end

  def handle_info({_ref, {:ai_response, ai_response}}, socket) do
    {:noreply, assign(socket, ai_response: ai_response, loading: false)}
  end

  def handle_info({:DOWN, _ref, :process, _pid, :normal}, socket) do
    {:noreply, socket}
  end
end
