@testset "build_summarize_prompt" begin
    article = Article("2610.06849", "Quantum dot blinking",
                      "We study photoluminescence intermittency...",
                      "pdf", "abs", "new", "date")
    prompt = ArticleParser.build_summarize_prompt(article)

    @test occursin("Quantum dot blinking", prompt)
    @test occursin("We study photoluminescence intermittency", prompt)
    @test occursin("русском", prompt)
    @test occursin("300–500 слов", prompt)
end