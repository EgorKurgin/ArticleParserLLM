@testset "build_filter_prompt" begin
    article = Article("2610.06849", "Quantum dot blinking", "We study...",
                      "pdf", "abs", "new", "date")
    prompt = ArticleParser.build_filter_prompt(article, "quantum dots")

    @test occursin("quantum dots", prompt)
    @test occursin("Quantum dot blinking", prompt)
    @test occursin("We study...", prompt)
    @test occursin("true", prompt)
    @test occursin("false", prompt)
end

@testset "parse_bool_response" begin
    @test ArticleParser.parse_bool_response("true")        === true
    @test ArticleParser.parse_bool_response("True")        === true
    @test ArticleParser.parse_bool_response("true.")       === true
    @test ArticleParser.parse_bool_response("Ответ: true") === true
    @test ArticleParser.parse_bool_response("false")       === false
    @test ArticleParser.parse_bool_response("False")       === false
    @test ArticleParser.parse_bool_response("false.")      === false

    # Неоднозначное — nothing
    @test ArticleParser.parse_bool_response("не знаю")   === nothing
    @test ArticleParser.parse_bool_response("")          === nothing
end