using ArticleParser
using Dates

function main()
    cfg = ArticleParser.load_config("config.toml")
    println("Категорий: ", length(cfg.categories))
    println("Категории: ", join(cfg.categories, ", "))

    # 1. Скачать RSS
    xml_path = ArticleParser.download_rss(cfg.categories;
                                          out_dir = cfg.out_dir,
                                          timeout = cfg.timeout)

    # 2. Распарсить
    articles = ArticleParser.parse_rss(xml_path)
    println("Найдено статей: ", length(articles))

    if isempty(articles)
        println("Сегодня статей нет — вероятно, выходной или ещё не было анонса.")
        return
    end

    # 3. Сохранить в JSONL
    out_dir  = joinpath(cfg.data_dir, "articles")
    out_path = joinpath(out_dir, "articles_$(Dates.today()).jsonl")
    ArticleParser.save_articles(articles, out_path)

    println("Готово: ", out_path)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end