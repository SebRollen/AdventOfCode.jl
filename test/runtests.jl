using AdventOfCode, Test, Mocking, HTTP, Dates
Mocking.activate()
@testset "All tests" begin
    AOC = AdventOfCode
    get_patch = @patch HTTP.get(a...; kw...) = (status = 200, body = "TESTDATA")
    get_error_patch = @patch HTTP.get(a...; kw...) = (status = 404, body = "ERROR")

    @testset "Basic Operations" begin
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
        @testset "_download_data" begin
            apply(get_patch) do
                @test AdventOfCode._download_data(2019, 1) == "TESTDATA"
            end
            apply(get_error_patch) do
                @test_throws ErrorException("Unable to download data") AdventOfCode._download_data(2019, 1)
            end
        end
    end
    for include_year in (true, false)
        data_path = "data/"
        src_path = "src/"
        if include_year
            data_path = joinpath(@__DIR__, "2019", data_path)
            src_path = joinpath(@__DIR__, "2019", src_path)
        else            
            data_path = joinpath(@__DIR__, data_path)
            src_path = joinpath(@__DIR__, src_path)
        end
        @testset "Include Year = $include_year" begin
            @testset "_template" begin
                @test AOC._template(2019, 1; include_year = include_year) == """
                # https://adventofcode.com/2019/day/1
                using AdventOfCode

                input = readlines("$(relpath(joinpath(data_path, "day_1.txt")))")

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
            @testset "setup_files" begin
                @testset "_setup_data_file" begin
                    apply(get_patch) do
                        try
                            AdventOfCode._setup_data_file(2019, 1, include_year = include_year)
                            @test isdir(data_path)
                            @test isfile(joinpath(data_path, "day_1.txt"))
                            @test readlines(joinpath(data_path, "day_1.txt")) == ["TESTDATA"]
                            @test_logs (:warn, r"will not redownload") AdventOfCode._setup_data_file(2019, 1; include_year = include_year)
                        finally
                            rm(data_path, recursive = true, force = true)
                        end
                    end
                end

                @testset "works for full method" begin
                    apply(get_patch) do
                        try
                            path = AdventOfCode.setup_files(2019, 1, force = true, include_year = include_year)
                            joinpath(src_path, "day_1.jl")
                            @test isdir(data_path)
                            @test isfile(joinpath(data_path, "day_1.txt"))
                            @test readlines(joinpath(data_path, "day_1.txt")) == ["TESTDATA"]
                            @test isdir(src_path)
                            @test isfile(joinpath(src_path, "day_1.jl"))
                            @test String(read(joinpath(src_path, "day_1.jl"))) == AdventOfCode._template(2019, 1,include_year = include_year)
                            @test_logs (:warn, Regex("$(joinpath(data_path, "day_1.txt")) already exists.")) (:warn, Regex("$(joinpath(src_path, "day_1.jl")) already exists.")) AdventOfCode.setup_files(2019, 1, force = false, include_year = include_year)
                        finally
                            rm("2020", recursive = true, force = true)
                            rm("2019", recursive = true, force = true)
                        end
                    end
                end
            end
        end
    end
end
