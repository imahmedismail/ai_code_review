# DeepSeek Code Analyzer - Phoenix LiveView

This is a **Phoenix LiveView** project that integrates with **DeepSeek R1** running locally on **Ollama** to analyze and provide feedback on any code snippet!

## 🚀 Features
- Uses **Tesla** to communicate with DeepSeek R1
- Runs DeepSeek R1 **locally** using **Ollama**
- Provides **real-time feedback** on small codebases, such as functions

## 🛠 Installation

### **1. Install Dependencies**
Ensure you have **Elixir**, **Erlang**, and **Phoenix** installed:

```sh
mix deps.get
```

### **2. Install and Run Ollama with DeepSeek R1**
- Install Ollama (if not installed):
```sh
curl -fsSL https://ollama.com/install.sh | sh
```
- Pull DeepSeek R1 model:
```sh
ollama pull deepseek-r1
```
- Run the model:
```sh
ollama run deepseek-r1
```

### **3. Run the Phoenix Server**
```
mix phx.server
```

## 🔗 API Integration
This project uses Tesla to send HTTP requests to DeepSeek R1 running on Ollama.

### Request Example:
```elixir
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
            send(pid, {:ai_response, "Error: Invalid response format from DeepSeek R1 on Ollama."})
        end

      {:error, reason} ->
        send(pid, {:ai_response, "Error: Failed to connect to DeepSeek R1 on Ollama: #{inspect(reason)}"})
    end
  end
```

## 🎯 Usage
1. Start Ollama with DeepSeek R1 running.
2. Run the Phoenix LiveView app.
3. Enter Elixir code in the UI and get feedback!

## 📹 Video Reference
https://github.com/user-attachments/assets/df605f0b-3dca-4a4d-9b33-8bc40c7d35f2

## 🤝 Contributing
Feel free to submit issues and pull requests!

## 📜 License
This project is open-source under the MIT License.
