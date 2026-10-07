struct Config
    categories ::Vector{String}
    out_dir    ::String
    timeout    ::Float64
    data_dir   ::String
end

function load_config(path::String = "config.toml")::Config
    isfile(path) || error("Файл конфигурации не найден: $path")
    cfg = TOML.parsefile(path)

    cats = get(get(cfg, "categories", Dict()), "list", String[])
    isempty(cats) && error("В конфиге пустой список категорий")

    dl = get(cfg, "download", Dict())
    paths = get(cfg, "paths", Dict())

    return Config(
        cats,
        get(dl, "out_dir", "data/rss"),
        get(dl, "timeout", 60.0),
        get(paths, "data_dir", "data"),
    )
end