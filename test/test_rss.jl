@testset "build_rss_url" begin
    url = ArticleParser.build_rss_url(["quant-ph"])
    @test url == "https://rss.arxiv.org/rss/quant-ph"

    url12 = ArticleParser.build_rss_url(["quant-ph", "cond-mat.str-el"])
    @test url12 == "https://rss.arxiv.org/rss/quant-ph+cond-mat.str-el" 
end

@testset "RSS parsing" begin
    sample_rss = joinpath(@__DIR__, "data", "sample_rss.xml")
    articles = ArticleParser.parse_rss(sample_rss)

    @test !isempty(articles)

    a = articles[1]
    @test !isempty(a.title)
    @test !isempty(a.id)
    @test !isempty(a.abstract)
    @test startswith(a.pdf_url, "https://arxiv.org/pdf/")
    @test a.announce_type in ("new", "replace", "cross")
end