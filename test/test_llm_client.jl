@testset "build_ollama_payload" begin
    payload = ArticleParser.build_ollama_payload("test prompt";
                                                 model="llama3.1:8b",
                                                 temperature=0.0,
                                                 num_predict=100)
    data = JSON3.read(payload)
    @test data.model == "llama3.1:8b"
    @test data.prompt == "test prompt"
    @test data.stream == false
    @test data.options.temperature == 0.0
    @test data.options.num_predict == 100
end