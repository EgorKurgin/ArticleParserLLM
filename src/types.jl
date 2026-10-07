struct Article
    id            ::String   
    title         ::String
    abstract      ::String
    pdf_url       ::String
    abs_url       ::String
    announce_type ::String   
    published     ::String   

    function Article(id, title, abstract, pdf_url, abs_url, announce_type, published)
        isempty(id)    && error("Article.id не может быть пустым")
        isempty(title) && error("Article.title не может быть пустым")
        new(String(id), String(title), String(abstract),
            String(pdf_url), String(abs_url),
            String(announce_type), String(published))
    end
end

function Base.show(io::IO, a::Article)
    print(io, "Article(", a.id, ", \"", first(a.title, 60), "…\")")
end