module Nest

export Indexer

#-----------------------------------------------------------------------------# Indexer
struct Indexer{T, K, V, P <: NamedTuple} <: AbstractDict{K, V}
    parent::T
    index_children::Dict{K, V}
    prop_children::P
end
function Indexer(x::T) where {T}
    index(x) = x isa T ? Indexer(x) : x
    Indexer(x,
        Dict(k => getindex(x, k) for k in keys(x)),
        NamedTuple(k => index(getproperty(x, k)) for k in propertynames(x))
    )
end
Base.summary(io::IO, idx::Indexer) = (print(io, "Indexer: "); summary(io, parent(idx)))

Base.iterate(idx::Indexer) = iterate(index_children(idx))
Base.iterate(idx::Indexer, state) = iterate(index_children(idx), state)
Base.length(idx::Indexer) = length(index_children(idx))

parent(idx::Indexer) = getfield(idx, :parent)
index_children(idx::Indexer) = getfield(idx, :index_children)
prop_children(idx::Indexer) = getfield(idx, :prop_children)

Base.getindex(idx::Indexer, key) = index_children(idx)[key]
Base.keys(idx::Indexer) = keys(index_children(idx))
Base.values(idx::Indexer) = values(index_children(idx))

Base.getproperty(idx::Indexer, key::Symbol) = prop_children(idx)[key]
Base.propertynames(idx::Indexer) = propertynames(prop_children(idx))


end
