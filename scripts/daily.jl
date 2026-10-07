using ArticleParser
using Dates

function main()
    cfg = ArticleParser.load_config("config.toml")
    println("Категорий: ", length(cfg.categories))

    # 1. Скачать RSS
    xml_path = ArticleParser.download_rss(cfg.categories;
                                          out_dir=cfg.out_dir,
                                          timeout=cfg.timeout)

    # 2. Распарсить
    articles = ArticleParser.parse_rss(xml_path)
    println("Найдено статей: ", length(articles))

    # 3. Сохранить в удобном формате (см. ниже)
    out_path = joinpath(cfg.data_dir, "articles_$(Dates.today()).jsonl")
    # ArticleParser.save_articles(articles, out_path)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end