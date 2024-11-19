using Nest

using Test

# completions(x) = Symbol.(REPLCompletions.completion_text.(REPLCompletions.completions(x, length(x))[1]))
completion_symbols(x) = Symbol.(completion_text.(completions(x, length(x))[1]))


@testset "Nest.jl" begin
    @testset "Fields" begin
        nt = (; a = (; b = (; c = (; d = 1))))
        f = Fields(nt)
        @test f.a.b.c.d == 1
    end
    @testset "Keys" begin
        d = Dict(:a => Dict(:b => Dict(:c => Dict(:d => 1))))
        @test Keys(d).a.b.c.d == 1
    end
    @testset "Setter" begin
        d = Dict{Symbol, Any}()
        k = Keys(d)
        s = Setter(Keys(d))
        @test (s.a.b.c.d = 1) == 1
        @test s.a.b.c.d == 1
    end
end
