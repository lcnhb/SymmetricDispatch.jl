using SymmetricDispatch
using Test
using MacroTools
using Combinatorics




struct A end
struct B end
struct C end
struct D end


@symmetric function p([a::A,b,c::B,d::D])
    @info "Abcd"
end

p(A(),A(),C(),D())
p(A(),B(),D(),C())  
p(B(),A(),C(),D())

methods(t)

quote combinedef(dict)
@testset "SymmetricDispatch.jl" begin


    # Write your tests here.
end