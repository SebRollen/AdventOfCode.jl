# AdventOfCode.jl Documentation

```@meta
DocTestSetup = quote
    using AdventOfCode
end
```

## Contents

```@contents
```

## Setup

`AdventOfCode.jl` exports one function, [`setup_files`](@ref) that lets you get up and
running with Advent of Code problems by downloading data and setting up your file structure.
To get started, you need an AdventOfCode cookie. Navigate to [www.adventofcode.com](https://www.adventofcode.com), log in with
whichever method you prefer and grab your cookie, using one of [these methods](https://kb.iu.edu/d/ajfi)
depending on your browser.

Once you have your cookie, store it in `ENV["AOC_SESSION"]`. After that, you should be ready
to use this package. Since the Advent of Code cookies are very long-lived, I suggest adding
`ENV["AOC_SESSION"] = {YOUR_COOKIE}` to your `~/.julia/config/startup.jl` file so that it's
always available when you start Julia.

## Documentation

```@autodocs
Modules = [AdventOfCode]
```

## Index

```@index
```
