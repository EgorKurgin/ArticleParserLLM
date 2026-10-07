const RSS_ITEM  = "//item"
const RSS_TITLE = "title"
const RSS_LINK  = "link"
const RSS_DESC  = "description"
const RSS_DATE  = "pubDate"

const RE_ARXIV_ID    = r"arXiv:(\d{4}\.\d{4,5})(v\d+)?"
const RE_ANN_TYPE    = r"Announce Type:\s*(\w+)"
const RE_ABSTRACT    = r"Abstract:\s*(.+)"s

function parse_rss(xml_path::String)
    doc   = readxml(xml_path)
    items = findall(RSS_ITEM, doc)

    articles = []
    for item in items
        title = text_of(item, RSS_TITLE)
        link  = text_of(item, RSS_LINK)
        desc  = text_of(item, RSS_DESC)
        date  = text_of(item, RSS_DATE)

        arxiv_id = ""
        m = match(RE_ARXIV_ID, desc)
        m !== nothing && (arxiv_id = m.captures[1])

        if isempty(arxiv_id)
            @warn "Пропускаю item без arXiv ID" title
            continue
        end

        announce_type = ""
        m = match(RE_ANN_TYPE, desc)
        m !== nothing && (announce_type = m.captures[1])

        abstract = ""
        m = match(RE_ABSTRACT, desc)
        m !== nothing && (abstract = strip(m.captures[1]))

        pdf_url = isempty(arxiv_id) ? "" : "https://arxiv.org/pdf/$arxiv_id"

        push!(articles, Article(
            arxiv_id,
            title,
            abstract,
            pdf_url,
            link,            # abs_url
            announce_type,
            date,
        ))
    end

    return articles
end

function text_of(node, tag)
    child = findfirst(tag, node)
    child === nothing ? "" : strip(nodecontent(child))
end