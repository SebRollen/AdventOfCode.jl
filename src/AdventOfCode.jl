module AdventOfCode

using HTTP, Dates, JSON
export setup_files

_base_url(year, day) = "https://adventofcode.com/$year/day/$day"

function _get_cookies()
    if "AOC_SESSION" ∉ keys(ENV)
        error("Session cookie in ENV[\"AOC_SESSION\"] needed to download data.")
    end
    return Dict("session" => ENV["AOC_SESSION"])
end

function _download_data(year, day)
    result = HTTP.get(_base_url(year, day) * "/input", cookies = _get_cookies())
    if result.status == 200
        return result.body
    end
    error("Unable to download data")
end

function _template(year, day)
    data_path = normpath(pwd() * "data/$year/day_$day.txt")
    """
    # $(_base_url(year, day))
    using AdventOfCode

    input = readlines("data/$year/day_$day.txt")

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

function _setup_data_file(year, day)
    data_path = joinpath(pwd(), "data/$year/day_$day.txt")
    time_req = HTTP.get("http://worldclockapi.com/api/json/est/now")
    current_datetime = JSON.parse(String(time_req.body))["currentDateTime"]
    current_date = Date(current_datetime[1:10])
    if current_date < Date(year, 12, day)
        @warn "AdventOfCode for year $year, day $day hasn't been unlocked yet."
    else
        data = _download_data(year, day)
        mkpath(splitdir(data_path)[1])
        open(data_path, "w+") do io
            write(io, data)
        end
    end
end

function _is_unlocked(year, day)
    time_req = HTTP.get("http://worldclockapi.com/api/json/est/now")
    current_datetime = JSON.parse(String(time_req.body))["currentDateTime"]
    current_date = Date(current_datetime[1:10])
    is_unlocked = current_date > Date(year, 12, day)
    if !is_unlocked
        @warn "Advent of Code for year $year and day $day hasn't unlocked yet."
    end
    is_unlocked
end

function setup_files(year, day; force = false)
    is_unlocked = _is_unlocked(year, day)
    code_path = joinpath(pwd(), "src/$year/day_$day.jl")
    is_unlocked && _setup_data_file(year, day)
    if !force && isfile(code_path)
        @warn "$code_path already exists. To overwrite, re-run with `force=true`"
    else
        mkpath(splitdir(code_path)[1])
        open(code_path, "w+") do io
            write(io, _template(year, day))
        end
    end
end
end
