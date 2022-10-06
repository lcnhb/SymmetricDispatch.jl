using SymmetricDispatch
using Test
using MacroTools
using Combinatorics




struct A end
struct B end
struct C end
struct D end
AA=Tuple{A,Any}
BB=Tuple{B,Any} 
CC=Tuple{C,Any}
DD=Tuple{D,Any}


@symmetric function t([a::AA,b::BB,c::CC,d::DD])
    a[2]
end 
methods(t)
t((A(),1),(B(),2),(C(),3),(D(),4))
t((B(),2),(A(),4),(C(),3),(D(),4))
t((B(),2),(B(),3),(A(),1),(D(),4))
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