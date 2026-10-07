using JSON3

function load_articles(path::String)::Vector{Article}
    articles = Article[]
    for line in eachline(path)
        isempty(strip(line)) && continue
        rec = JSON3.read(line)
        push!(articles, Article(
            rec.id,
            rec.title,
            rec.abstract,
            rec.pdf_url,
            "",              # abs_url не сохраняем — не критично
            rec.announce_type,
            "",              # published тоже
        ))
    end
    return articles
end