using AdventOfCode, Test, Mocking

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
end
