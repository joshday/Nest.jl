# Nest

[![Build Status](https://github.com/joshday/Nest.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/joshday/Nest.jl/actions/workflows/CI.yml?query=branch%3Amain)

Utilites for working with nested data structures in Julia.

## Usage

```julia
using Nest

d = Dict()

obj = Setter(Keys(d))

obj.a.b.c = 1

d[:a][:b][:c] == 1

Keys(d).a.b.c == 1
```
