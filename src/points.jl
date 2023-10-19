module Points 

using ..ElementaryObjects

export Point

struct Point 
    x::Float64
    y::Float64
    z::Float64
end

function Point(v::Vector{T}) where T <: Real
    Point(
        Float64.(v)...
    )
end

"""Base.+(p1::Point, p2::Point) = Point(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
function Base.+(p::Point, v::Vector{T}) where T <: Real
    +(p, Point(v))
end
function Base.+(v::Vector(T), p::Point) where T <: Real
    +(p, v)
end
"""
ElementaryObjects.construct_pov(point::Point) = "<$(point.x), $(point.y), $(point.z)>"

end