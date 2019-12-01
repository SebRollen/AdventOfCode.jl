using AdventOfCode, Test, Mocking, HTTP
Mocking.activate()
@testset "All tests" begin
    AOC = AdventOfCode
    @testset "_is_unlocked" begin
        @test AOC._is_unlocked(2018, 1)
        @test (@test_logs (:warn, "Advent of Code for year 3000 and day 1 hasn't unlocked yet.") !AOC._is_unlocked(3000, 1))
    end
    @testset "_get_cookies" begin
        cleanup = false
        if "AOC_SESSION" ∈ keys(ENV)
            temp = ENV["AOC_SESSION"]
            cleanup = true
        end
        ENV["AOC_SESSION"] = "COOKIE"
        @test AOC._get_cookies() == Dict("session" => "COOKIE")
        if cleanup
            ENV["AOC_SESSION"] = temp
        end
    end
    @testset "_base_url" begin
        @test AOC._base_url(2019, 1) == "https://adventofcode.com/2019/day/1"
    end
    @testset "_template" begin
        @test AOC._template(2019, 1) == """
        # https://adventofcode.com/2019/day/1
        using AdventOfCode

        input = readlines("data/2019/day_1.txt")

        function part_1(input)
            nothing
        end
        @info part_1(input)

        function part_2(input)
            nothing
        end
        @info part_2(input)
        """
    end
    get_patch = @patch HTTP.get(a...; kw...) = (status = 200, body = "TESTDATA")
    @testset "_download_data" begin
        apply(get_patch) do
            @test AdventOfCode._download_data(2019, 1) == "TESTDATA"
        end
    end
    @testset "_setup_data_file" begin
        apply(get_patch) do
            AdventOfCode._setup_data_file(2019, 1)
            @test isdir("data/2019")
            @test isfile("data/2019/day_1.txt")
            @test readlines("data/2019/day_1.txt") == ["TESTDATA"]
        end
    end
    @testset "setup_files" begin
        apply(get_patch) do
            AdventOfCode.setup_files(2019, 1, force = true)
            @test isdir("data/2019")
            @test isfile("data/2019/day_1.txt")
            @test readlines("data/2019/day_1.txt") == ["TESTDATA"]
            @test isdir("src/2019")
            @test isfile("src/2019/day_1.jl")
            @test String(read("src/2019/day_1.jl")) == AdventOfCode._template(2019, 1)
        end
    end
end
rm("data", recursive = true)
rm("src", recursive = true)
