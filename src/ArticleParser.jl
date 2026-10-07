module ArticleParser

using Downloads
using Dates
using TOML
using EzXML
using JSON3
using HTTP

include("types.jl")
include("config.jl")
include("rss_download.jl")
include("rss_parser.jl")
include("save.jl")

include("llm_client.jl")
include("llm_filter.jl")

# Публичный API
export Article, Config
export load_config
export build_rss_url, download_rss, parse_rss
export save_articles

export ollama_generate
export is_relevant

end # module ArticleParser