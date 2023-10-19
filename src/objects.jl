module Objects

using ..ElementaryObjects
using ..Points
using Colors

export Object, BasicShape
export Sphere
export Colored
export CSG, CSGUnion

abstract type Object <: POV end
abstract type BasicShape <: Object end
abstract type CSG <: Object end

struct Sphere <: BasicShape
    position::Point3D
    radius::Float64

    Sphere(position, radius) = new(Point3D(position), radius)
end

Sphere() = Sphere([0.0, 0.0, 0.0], 1.0)

struct Colored{T<:Object} <: Object
    object::T
    rgbft::RGBFT
end

struct CSGUnion <: CSG 
    objects::Vector{Object}
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
    return str[1:collect(index)[1]-1] * 
"   pigment{
        $(construct_pov(cobject.rgbft))
    }
}"
end

function ElementaryObjects.construct_pov(union::CSGUnion)
    str="union{\n"
    for o in union.objects
        str *= "    " * construct_pov(o) * "\n"
    end
    return str * "}"
end


end