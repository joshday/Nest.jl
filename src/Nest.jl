module Nest

export Fields, Keys, Setter, @fields, @keys, @setter

#-----------------------------------------------------------------------------# utils
abstract type PropertyMap{T} end

item(x) = x
item(x::PropertyMap) = getfield(x, :item)
function Base.show(io::IO, x::T) where {T <: PropertyMap}
    print(io, T.name.name, " of ")
    Base.show(io, MIME("text/plain"), item(x))
end

is_nestable(x) = false
is_nestable(::AbstractDict) = true
is_nestable(::PropertyMap) = true
_wrap(T, x) = is_nestable(x) ? T(x) : x

Base.length(x::PropertyMap) = length(item(x))
Base.pairs(x::PropertyMap) = pairs(item(x))
Base.iterate(x::PropertyMap, state...) = iterate(item(x), state...)


#-----------------------------------------------------------------------------# Fields
struct Fields{T} <: PropertyMap{T}
    item::T
end
Fields{T}() where {T} = Fields(T())
Base.propertynames(o::Fields{T}) where {T} = fieldnames(T)
Base.getproperty(o::Fields{T}, sym::Symbol) where {T} = _wrap(Fields, getfield(item(o), sym))
Base.setproperty!(o::Fields{T}, sym::Symbol, val) where {T} = setfield!(item(o), sym, val)


#-----------------------------------------------------------------------------# Keys
struct Keys{T} <: PropertyMap{T}
    item::T
end
Keys{T}() where {T} = Keys(T())
Base.propertynames(k::Keys) = keys(item(k))
Base.getproperty(k::Keys, sym::Symbol) = _wrap(Keys, getindex(item(k), sym))
Base.setproperty!(k::Keys, sym::Symbol, val) = setindex!(getfield(k, :item), val, sym)


#-----------------------------------------------------------------------------# Setter
struct Setter{T} <: PropertyMap{T}
    item::T
end

Base.propertynames(s::Setter{T}) where {T} = propertynames(item(s))

base_item(x) = x
base_item(o::PropertyMap) = base_item(item(o))

function Base.getproperty(s::Setter{T}, sym::Symbol) where {T}
    hasproperty(s, sym) || setproperty!(item(s), sym, base_item(T()))
    out = getproperty(item(s), sym)
    _wrap(Setter{T}, out)
end

Base.setproperty!(s::Setter{T}, sym::Symbol, val) where {T} = setproperty!(item(s), sym, val)

#-----------------------------------------------------------------------------# macros
function wrap_first_arg(e::Expr, wrapper::Expr)
    e.head == :. && return Expr(:., wrap_first_arg(e.args[1], wrapper), e.args[2:end]...)
    e.head == :(=) && return Expr(:(=), wrap_first_arg(e.args[1], wrapper), e.args[2])
    Expr(wrapper.head, wrapper.args..., e)
end
wrap_first_arg(e::Symbol, wrapper::Expr) = Expr(wrapper.head, wrapper.args..., e)

macro fields(ex)
    esc(wrap_first_arg(ex, Expr(:call, :(Nest.Fields))))
end
macro keys(ex)
    esc(wrap_first_arg(ex, Expr(:call, :(Nest.Keys))))
end
macro setter(ex)
    esc(wrap_first_arg(ex, Expr(:call, :(Nest.Setter))))
end


end
