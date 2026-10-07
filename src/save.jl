using JSON3

function save_articles(articles::Vector{Article}, path::String)
    dir = dirname(path)
    isempty(dir) || mkpath(dir)

    open(path, "w") do io
        for (i, a) in enumerate(articles)
            record = (
                i             = i,
                id            = a.id,
                title         = a.title,
                abstract      = a.abstract,
                pdf_url       = a.pdf_url,
                announce_type = a.announce_type,
            )
            println(io, JSON3.write(record))
        end
    end

    @info "Сохранено" path count=length(articles)
    return length(articles)
end