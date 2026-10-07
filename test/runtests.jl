using Test 
using ArticleParser 

@testset "ArxivParser" begin
    include("test_config.jl")
    include("test_rss.jl")
    include("test_save.jl")
    include("test_llm_client.jl")
end