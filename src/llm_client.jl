using HTTP
using JSON3

const OLLAMA_URL     = "http://127.0.0.1:11434/api/generate"
const OLLAMA_MODEL   = "llama3.1:8b"
const OLLAMA_TIMEOUT = 600.0

function build_ollama_payload(prompt::String;
                              model::String        = OLLAMA_MODEL,
                              temperature::Float64 = 0.1,
                              num_predict::Int     = 1024)
    return JSON3.write(Dict(
        "model"   => model,
        "prompt"  => prompt,
        "stream"  => false,
        "options" => Dict(
            "temperature" => temperature,
            "num_predict" => num_predict,
        ),
    ))
end

function ollama_generate(prompt::String;
                         url::String      = OLLAMA_URL,
                         timeout::Float64 = OLLAMA_TIMEOUT,
                         kwargs...)
    payload = build_ollama_payload(prompt; kwargs...)

    response = HTTP.post(url,
        ["Content-Type" => "application/json"],
        payload;
        request_timeout = timeout)  

    if response.status != 200
        error("Ollama вернул статус $(response.status): $(String(response.body))")
    end

    data = JSON3.read(response.body)
    return String(data.response)
end