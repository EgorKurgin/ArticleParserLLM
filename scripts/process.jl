using ArticleParser
using Dates

function main()
    isempty(ARGS) && error("Укажите путь к JSONL: julia scripts/process.jl data/articles/articles_2026-10-07.jsonl")

    articles_path = ARGS[1]
    tag = replace(basename(articles_path), r"\.jsonl$" => "")

    interests = read("interests.txt", String)
    articles  = load_articles(articles_path)

    @info "Загружено статей" count=length(articles) path=articles_path

    filtered_path  = joinpath("data", "filtered",  "$tag.jsonl")
    summaries_path = joinpath("data", "summaries", "$tag.md")

    stats = process_articles(articles, interests;
                             filtered_path=filtered_path,
                             summaries_path=summaries_path)

    println()
    println("Итог:")
    println("  Всего статей:     ", stats.total)
    println("  Новых обработано: ", stats.new)
    println("  Оставлено:        ", stats.kept)
    println("  JSONL:            ", filtered_path)
    println("  Markdown:         ", summaries_path)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end