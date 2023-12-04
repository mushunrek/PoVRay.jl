module Objects

using ..ElementaryObjects
using Colors

export Object, BasicShape, BasicObject
export Sphere, BasicSphere
export Colored
export CSG, CSGUnion

abstract type Object <: AbstractPoVRay end
abstract type BasicShape <: Object end
abstract type CSG <: Object end

struct BasicObject <: Object 
    tag::String
    properties::Vector{AbstractPoVRay}
    modifiers::Dict{Symbol, AbstractPoVRay}

    function BasicObject(tag, properties, modifiers; force_creation=false)
        if force_creation == true
            return new(tag, properties, modifiers)
        end
        error("Please refer to `?BasicObject` on how to correctly implement a new BasicObject")
    end
end

Base.getindex(o::BasicObject, modif::Symbol) = o.modifiers[modif]
function Base.setindex!(o::BasicObject, p::POV, modif::Symbol)
    o.modifiers[modif] = p
end

function ElementaryObjects.construct_pov(o::BasicObject)
    "$(o.tag){\n\t$(join( construct_pov.(o.properties), "\n\t"))\n}"
end

BasicSphere(position, radius) = BasicObject("sphere", [Point3D(position), RealPOV(radius)], Dict(), force_creation=true)

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