function applyPerm(perm,vector)
  newVector=copy(vector)
  for (i,j) in enumerate(perm)
      newVector[i]=vector[j]
  end
  newVector
end


function invertPerm(perm,vector)
  newVector=copy(vector)
  for (i,j) in enumerate(perm)
      newVector[j]=vector[i]
  end
  newVector
end

function combineargs(arguments)
  [combinearg(arg...) for arg in arguments]
end

macro symmetric(def)
dict=splitdef(def)
arguments=map(splitarg,dict[:args]) 


symargs=[]
indices=[]
nargs=0 
newarguments=[]

for arg in arguments
  if isexpr((arg[1]),Symbol)
      push!(newarguments,arg)
      nargs+=1
  else
      addsymargs=(splitarg.(arg[1].args))
      push!(newarguments,addsymargs...)
      nnewsymargs =length(addsymargs)
      push!(indices,(nargs+1:nargs+nnewsymargs)...)
      nargs+=nnewsymargs
      push!(symargs,addsymargs...)
  end
end 
arguments=newarguments
dict[:args]=combineargs(arguments)
argtypes=map(x->x[2],symargs)


perms=collect(multiset_permutations(argtypes,length(argtypes)))


n=length(argtypes)
m=length(perms)


MATCHED  = gensym()
if isexpr(perms[1][1])
   MATCHED=:($MATCHED,n)
end
intperms=Array{Int}(undef, m,n)
for (i,perm) in enumerate(perms)
for (j,type) in enumerate(argtypes)
  k  =findfirst(x -> inexpr(x,type),perm)
  perm[k]=MATCHED
  intperms[i,j]=k
end
end

fns=Vector{Expr}(undef,length(intperms[:,1]))
fns[1]=esc(combinedef(dict))
for (i,perm) in enumerate(eachrow(intperms[2:end,:]))

  cdict=copy(dict)
  carguments = copy(arguments)
  carguments[indices]  = applyPerm(perm,arguments[indices])
  argu  =map(x->x[1],arguments)
  body=:($(dict[:name])($(argu...)))
  cdict[:body]=body
  cdict[:args]=combineargs(carguments)
  fns[i+1]=esc(MacroTools.combinedef(cdict))
end

return quote $(fns...) end
end
