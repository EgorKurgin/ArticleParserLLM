using JSON3

@testset "save_articles" begin
    # Готовим две статьи
    articles = [
        Article("2610.06849", "Title 1", "Abstract 1",
                "https://arxiv.org/pdf/2610.06849",
                "https://arxiv.org/abs/2610.06849",
                "new", "Mon, 06 Oct 2026 00:00:00 -0400"),
        Article("2610.06845", "Title 2", "Abstract 2",
                "https://arxiv.org/pdf/2610.06845",
                "https://arxiv.org/abs/2610.06845",
                "replace", "Mon, 06 Oct 2026 00:00:00 -0400"),
    ]

    # Пишем во временный файл
    path = tempname() * ".jsonl"
    try
        n = ArticleParser.save_articles(articles, path)
        @test n == 2
        @test isfile(path)

        # Читаем обратно
        lines = readlines(path)
        @test length(lines) == 2

        # Каждая строка — валидный JSON
        rec1 = JSON3.read(lines[1])
        @test rec1.i == 1
        @test rec1.id == "2610.06849"
        @test rec1.title == "Title 1"
        @test rec1.announce_type == "new"

        rec2 = JSON3.read(lines[2])
        @test rec2.i == 2
        @test rec2.id == "2610.06845"
        @test rec2.announce_type == "replace"
    finally
        isfile(path) && rm(path)
    end
end

@testset "save_articles — пустой вектор" begin
    path = tempname() * ".jsonl"
    try
        n = ArticleParser.save_articles(Article[], path)
        @test n == 0
        @test isfile(path)                   # файл создан
        @test isempty(readlines(path))       # но пустой
    finally
        isfile(path) && rm(path)
    end
end