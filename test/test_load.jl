@testset "load_articles" begin
    # Пишем временный JSONL
    path = tempname() * ".jsonl"
    try
        write(path, """
        {"i":1,"id":"2610.06849","title":"T1","abstract":"A1","pdf_url":"p1","announce_type":"new"}
        {"i":2,"id":"2610.06845","title":"T2","abstract":"A2","pdf_url":"p2","announce_type":"replace"}

        """)

        articles = ArticleParser.load_articles(path)
        @test length(articles) == 2
        @test articles[1].id == "2610.06849"
        @test articles[2].title == "T2"
        @test articles[2].announce_type == "replace"
    finally
        isfile(path) && rm(path)
    end
end

@testset "load_processed_ids — нет файла" begin
    ids = ArticleParser.load_processed_ids("нет_такого.jsonl")
    @test isempty(ids)
end

@testset "append_filtered + load_processed_ids" begin
    path = tempname() * ".jsonl"
    try
        ArticleParser.append_filtered(path, "id1", true;  summary="текст")
        ArticleParser.append_filtered(path, "id2", false)
        ArticleParser.append_filtered(path, "id3", true;  summary="ещё")

        ids = ArticleParser.load_processed_ids(path)
        @test ids == Set(["id1", "id2", "id3"])

        lines = readlines(path)
        @test length(lines) == 3

        rec1 = JSON3.read(lines[1])
        @test rec1.relevant == true
        @test rec1.summary == "текст"
        rec2 = JSON3.read(lines[2])
        @test rec2.relevant == false
        @test !haskey(rec2, :summary)
    finally
        isfile(path) && rm(path)
    end
end