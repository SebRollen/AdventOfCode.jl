using AdventOfCode, Test, Mocking, HTTP, Dates
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
            temp = pop!(ENV, "AOC_SESSION")
            cleanup = true
        end
        @test_throws ErrorException("Session cookie in ENV[\"AOC_SESSION\"] needed to download data.") AOC._get_cookies()
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
    get_error_patch = @patch HTTP.get(a...; kw...) = (status = 404, body = "ERROR")
    @testset "_download_data" begin
        apply(get_patch) do
            @test AdventOfCode._download_data(2019, 1) == "TESTDATA"
        end
        apply(get_error_patch) do
            @test_throws ErrorException("Unable to download data") AdventOfCode._download_data(2019, 1)
        end
    end
    @testset "_setup_data_file" begin
        apply(get_patch) do
            try
                AdventOfCode._setup_data_file(2019, 1)
                @test isdir("data/2019")
                @test isfile("data/2019/day_1.txt")
                @test readlines("data/2019/day_1.txt") == ["TESTDATA"]
                @test_logs (:warn, r"will not redownload") AdventOfCode._setup_data_file(2019, 1)
            finally
                rm("data", recursive = true, force = true)
            end
        end
    end
    @testset "setup_files" begin
        @testset "works for full method" begin
            apply(get_patch) do
                try
                    path = AdventOfCode.setup_files(2019, 1, force = true)
                    dir_path = @__DIR__
                    joinpath(dir_path, "src", "2019", "day_1.jl")
                    @test isdir("data/2019")
                    @test isfile("data/2019/day_1.txt")
                    @test readlines("data/2019/day_1.txt") == ["TESTDATA"]
                    @test isdir("src/2019")
                    @test isfile("src/2019/day_1.jl")
                    @test String(read("src/2019/day_1.jl")) == AdventOfCode._template(2019, 1)
                    @test_logs (:warn, r"data/2019/day_1.txt already exists.") (:warn, r"src/2019/day_1.jl already exists.") AdventOfCode.setup_files(2019, 1, force = false)
                finally
                    rm("data", recursive = true, force = true)
                    rm("src", recursive = true, force = true)
                end
            end
        end
        @testset "works for convenience method" begin
            apply(get_patch) do
                try
                    year, day = Dates.year(today()), Dates.day(today())
                    path = AdventOfCode.setup_files(force = true)
                    dir_path = @__DIR__
                    joinpath(dir_path, "src", string(year), "day_$day.jl")
                    @test isdir("data/$year")
                    @test isfile("data/$year/day_$day.txt")
                    @test readlines("data/$year/day_$day.txt") == ["TESTDATA"]
                    @test isdir("src/$year")
                    @test isfile("src/$year/day_$day.jl")
                    @test String(read("src/$year/day_$day.jl")) == AdventOfCode._template(year, day)
                    @test_logs (:warn, r"txt already exists.") (:warn, r"jl already exists.") AdventOfCode.setup_files(year, day, force = false)
                finally
                    rm("data", recursive = true, force = true)
                    rm("src", recursive = true, force = true)
                end
            end
        end
    end
end
