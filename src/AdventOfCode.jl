module AdventOfCode

using HTTP, Dates, JSON
using Mocking
export setup_files

_base_url(year, day) = "https://adventofcode.com/$year/day/$day"

function _get_cookies()
    if "AOC_SESSION" ∉ keys(ENV)
        error("Session cookie in ENV[\"AOC_SESSION\"] needed to download data.")
    end
    return Dict("session" => ENV["AOC_SESSION"])
end

function _download_data(year, day)
    result = @mock HTTP.get(_base_url(year, day) * "/input", cookies = _get_cookies())
    if result.status == 200
        return result.body
    end
    error("Unable to download data")
end

function _template(year, day; include_year = true)
    rel_path = joinpath("data", "day_$day.txt")
    include_year && (rel_path = joinpath(string(year), rel_path))
    
    """
    # $(_base_url(year, day))

    input = readlines("$rel_path")

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

function _setup_data_file(year, day; include_year = true)
    rel_path = joinpath("data", "day_$day.txt")
    include_year && (rel_path = joinpath(string(year), rel_path))

    data_path = joinpath(pwd(), rel_path)
    if isfile(data_path)
        @warn "$data_path already exists. AdventOfCode.jl will not redownload it"
        return nothing
    end
    if _is_unlocked(year, day)
        data = _download_data(year, day)
        mkpath(splitdir(data_path)[1])
        open(data_path, "w+") do io
            write(io, data)
        end
    end
end

function _is_unlocked(year, day)
    time_req = HTTP.get("http://worldtimeapi.org/api/timezone/EST")
    current_datetime = JSON.parse(String(time_req.body))["datetime"]
    current_date = Date(current_datetime[1:10])
    is_unlocked = current_date >= Date(year, 12, day)
    if !is_unlocked
        @warn "Advent of Code for year $year and day $day hasn't unlocked yet."
    end
    is_unlocked
end

"""
    setup_files(year, day; force = false, include_year = true)
    setup_files(; force = false, include_year = true)

Downloads the input file for the specified year and date and stores that file in
`{year}/data/day_{day}.txt` or `data/day_{day}.txt` if `include_year` is set to `false`.
Also sets up a template file in `{year}/src/day_{day}.jl` for your script
(`src/day_{day}.jl` if `include_year` is set to `false`). 
`force=true` will recreate the `src` file even if it already exists. 
The `data` file will not be re-downloaded even with `force=true` 
since it's a static file and to reduce load on AdventOfCode's servers.

If `year` and `day` are not provided, the setup defaults to today's date.
"""
function setup_files(year, day; force = false, include_year = true)
    is_unlocked = _is_unlocked(year, day)
    rel_path = joinpath("src", "day_$day.jl")
    include_year && (rel_path = joinpath(string(year), rel_path))
    code_path = joinpath(pwd(), rel_path)
    is_unlocked &&  _setup_data_file(year, day, include_year = include_year)
    if !force && isfile(code_path)
        @warn "$code_path already exists. To overwrite, re-run with `force=true`"
    else
        mkpath(splitdir(code_path)[1])
        open(code_path, "w+") do io
            write(io, _template(year, day, include_year=include_year))
        end
    end
    return code_path
end

setup_files(; force = false, include_year = true) = setup_files(year(today()), day(today()), force = force, include_year = include_year)

end
