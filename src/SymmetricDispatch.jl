module SymmetricDispatch

using MacroTools
using MacroTools: combinearg
using Combinatorics
export @symmetric 

include("symmetric.jl")

end
