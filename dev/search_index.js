var documenterSearchIndex = {"docs":
[{"location":"#AdventOfCode.jl-Documentation-1","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"","category":"section"},{"location":"#","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"DocTestSetup = quote\n    using AdventOfCode\nend","category":"page"},{"location":"#Contents-1","page":"AdventOfCode.jl Documentation","title":"Contents","text":"","category":"section"},{"location":"#","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"","category":"page"},{"location":"#Setup-1","page":"AdventOfCode.jl Documentation","title":"Setup","text":"","category":"section"},{"location":"#","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"AdventOfCode.jl exports one function, setup_files that lets you get up and running with AdventOfCode.com problems by downloading data and setting up your file structure. To get started, you need an AdventOfCode cookie. Navigate to www.adventofcode.com, log in with whichever method you prefer and grab your cookie, using one of these methods depending on your browser.","category":"page"},{"location":"#","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"Once you have your cookie, store it in ENV[\"AOC_SESSION\"]. After that, you should be ready to use this package. Since the Advent of Code cookies are very long-lived, I suggest adding ENV[\"AOC_SESSION\"] = {YOUR_COOKIE} to your ~/.julia/config/startup.jl file so that it's always available when you start Julia.","category":"page"},{"location":"#Documentation-1","page":"AdventOfCode.jl Documentation","title":"Documentation","text":"","category":"section"},{"location":"#","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"Modules = [AdventOfCode]","category":"page"},{"location":"#AdventOfCode.setup_files-Tuple{Any,Any}","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.setup_files","text":"setup_files(year, day; force = false)\n\nDownloads the input file for the specified year and date and stores that file in data/{year}/day_{day}.txt. Also sets up a template file in src/{year}/day_{day}.jl for your script. force=true will recreate the src file even if it already exists. The data file will not be re-downloaded even with force=true since it's a static file and to reduce load on AdventOfCode's servers.\n\n\n\n\n\n","category":"method"},{"location":"#Index-1","page":"AdventOfCode.jl Documentation","title":"Index","text":"","category":"section"},{"location":"#","page":"AdventOfCode.jl Documentation","title":"AdventOfCode.jl Documentation","text":"","category":"page"}]
}
