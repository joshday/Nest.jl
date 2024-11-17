using Nest

using REPL.REPLCompletions
using Test

# completions(x) = Symbol.(REPLCompletions.completion_text.(REPLCompletions.completions(x, length(x))[1]))
completion_symbols(x) = Symbol.(completion_text.(completions(x, length(x))[1]))


@testset "Nest.jl" begin
    @testset "NamedTuple" begin
        nt = (; a = (; b = (; c = (; d = 1))), b=(; c = 2))
        idx = Indexer(nt)
        @test completion_symbols("idx.") == [:a, :b]
        @test completion_symbols("idx.a.") == [:b]
        @test completion_symbols("idx.a.b.") == [:c]
        @test completion_symbols("idx.a.b.c.") == [:d]
        @test idx.a.b.c.d == 1
    end
end
