module Objects

using ..ElementaryObjects
using ..Points
using Colors

export Object, BasicShape
export Sphere
export Colored 

abstract type Object <: POV end
abstract type BasicShape <: Object end

struct Sphere <: BasicShape
    position::Point
    radius::Float64

    Sphere(position, radius) = new(Point(position), radius)
end

Sphere() = Sphere([0.0, 0.0, 0.0], 1.0)


struct Colored{T<:Object} <: Object
    object::T
    rgbft::RGBFT
end


function ElementaryObjects.construct_pov(s::Sphere)
    "sphere{
        $(construct_pov(s.position))
        $(s.radius)
    }"
end

function ElementaryObjects.construct_pov(cobject::Colored{T}) where T <: Object
    str = construct_pov(cobject.object)
    index = findlast("}", str)
    return str[1:collect(index)[1]-1] * "
        pigment{
            $(construct_pov(cobject.rgbft))
        }
    }"
end


end