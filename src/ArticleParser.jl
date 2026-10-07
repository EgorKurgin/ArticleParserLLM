module ArticleParser

using Downloads
using Dates
using TOML
using EzXML
using JSON3

include("types.jl")
include("config.jl")
include("rss_download.jl")
include("rss_parser.jl")
include("save.jl")

# Публичный API
export Article, Config
export load_config
export build_rss_url, download_rss, parse_rss
export save_articles

end # module ArticleParser