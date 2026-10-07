using Test 
using ArticleParser 

@testset "ArxivParser" begin
    include("test_config.jl")
    include("test_rss.jl")
    include("test_save.jl")
end