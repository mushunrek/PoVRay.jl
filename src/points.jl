module Points

using ..ElementaryObjects

export Point3D

struct Point3D 
    x::Float64
    y::Float64
    z::Float64
end

function Point3D(v::Vector{T}) where T <: Real
    Point3D(
        Float64.(v)...
    )
end

"""Base.+(p1::Point3D, p2::Point3D) = Point3D(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
function Base.+(p::Point3D, v::Vector{T}) where T <: Real
    +(p, Point3D(v))
end
function Base.+(v::Vector(T), p::Point3D) where T <: Real
    +(p, v)
end
"""
ElementaryObjects.construct_pov(point::Point3D) = "<$(point.x), $(point.y), $(point.z)>"

end