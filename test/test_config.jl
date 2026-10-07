@testset "load_config" begin

    # --- 1. Полный валидный конфиг ---
    @testset "полный конфиг" begin
        path = joinpath(@__DIR__, "data", "valid_config.toml")
        cfg = ArticleParser.load_config(path)

        @test cfg isa ArticleParser.Config
        @test cfg.categories == ["quant-ph", "cond-mat.str-el"]
        @test cfg.out_dir == "test_out/rss"
        @test cfg.timeout == 30.0
        @test cfg.data_dir == "test_data"
    end

    # --- 2. Минимальный конфиг: подставляются дефолты ---
    @testset "минимальный конфиг" begin
        path = joinpath(@__DIR__, "data", "minimal_config.toml")
        cfg = ArticleParser.load_config(path)

        @test cfg.categories == ["cs.AI"]
        @test cfg.out_dir == "data/rss"       # дефолт
        @test cfg.timeout == 60.0             # дефолт
        @test cfg.data_dir == "data"          # дефолт
    end

    # --- 3. Файл не существует ---
    @testset "отсутствующий файл" begin
        @test_throws ErrorException ArticleParser.load_config("нет_такого.toml")
    end

    # --- 4. Пустой список категорий ---
    @testset "пустой список категорий" begin
        path = joinpath(@__DIR__, "data", "empty_categories.toml")
        @test_throws ErrorException ArticleParser.load_config(path)
    end

    # --- 5. Секция [categories] отсутствует ---
    @testset "нет секции [categories]" begin
        path = joinpath(@__DIR__, "data", "no_categories_section.toml")
        @test_throws ErrorException ArticleParser.load_config(path)
    end

    # --- 6. Типы полей ---
    @testset "типы полей" begin
        path = joinpath(@__DIR__, "data", "valid_config.toml")
        cfg = ArticleParser.load_config(path)

        @test cfg.categories isa Vector{String}
        @test cfg.out_dir isa String
        @test cfg.timeout isa Float64
        @test cfg.data_dir isa String
    end

end