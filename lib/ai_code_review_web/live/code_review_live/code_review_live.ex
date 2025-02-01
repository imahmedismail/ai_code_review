defmodule AiCodeReviewWeb.CodeReviewLive do
  use AiCodeReviewWeb, :live_view
  alias Tesla
  alias Jason

  def mount(_params, _session, socket) do
    {:ok, assign(socket, ai_response: nil)}
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
          rows="10">
        </textarea>

        <button
          type="submit"
          class="bg-blue-500 text-white px-4 py-2 rounded">
          Analyze Code
        </button>
      </form>

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
    case analyze_code_with_deepseek(code) do
      {:ok, ai_response} ->
        {:noreply, assign(socket, ai_response: ai_response)}
      {:error, error_msg} ->
        {:noreply, assign(socket, ai_response: "Error: #{error_msg}")}
    end
  end

  defp analyze_code_with_deepseek(code) do
    url = "http://localhost:11434/api/generate" # Local Ollama API URL

    body = %{
      "model" => "deepseek-r1",  # Use "deepseek-r1" if needed
      "prompt" => "Analyze this code and provide feedback: \n\n#{code}",
      "stream" => false
    }

    headers = [{"Content-Type", "application/json"}]

    case Tesla.post(url, Jason.encode!(body), headers: headers) do
      {:ok, %{status: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"response" => response}} -> {:ok, response}
          _ -> {:error, "Invalid response format from DeepSeek R1 on Ollama."}
        end
      {:error, reason} ->
        {:error, "Failed to connect to DeepSeek R1 on Ollama: #{inspect(reason)}"}
    end
  end

end
