const RSS_BASE = "https://rss.arxiv.org/rss/"

function build_rss_url(categories::Vector{String})
    isempty(categories) && error("Список категорий пуст")
    return "$RSS_BASE" * join(categories, "+")
end


function download_rss(categories::Vector{String};
                      out_dir::String="data/rss",
                      timeout::Float64=60.0)
    url = build_rss_url(categories)
    @info "Запрос RSS" url
    
    mkpath(out_dir)
    stamp = Dates.format(now(), "yyyy-mm-dd_HH_MM_SS")
    path  = joinpath(out_dir, "rss_$stamp.xml")

    Downloads.download(url, path;
        headers=["User-Agent" => "ArticleParser v0.1 (kurginegor1901@gmail.com)"],
        timeout=timeout)

    @info "Сохранено" path filesize(path)
    return path
end 