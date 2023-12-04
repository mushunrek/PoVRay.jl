module Objects

using ..ElementaryObjects
using Colors

export PoVRayObject
export Sphere
export Colored, color!
export Union
#export CSG, CSGUnion

"""
    Object(tag, descriptors, modifiers)

Implementation of PoVRay objects. This type is not to be instantiated through
its constructor! Doing so will throw an error. Instead, any `Object` should be 
instantiated through one of the specialized constructor, e.g.
    Sphere(position, radius)
    Colored(object, rgbft)

# Fields 
- `tag::String`: describes what type of object it is. These correspond to the 
    object names from PoVRay, see also the [official webpage](https://www.povray.org/documentation/view/3.7.1/273/).
- `descriptors::Tuple{AbstractPoVRay}`: Immutable list of descriptors defining 
    the object. For a sphere, the descriptors are its position and its radius.
- `modifiers::Dict{Symbol, AbstractPoVRay}`: Dictionary containing modifiers 
    for the object. Common modifiers are `:translate`, `:rotate` and `:scale`.
    Pigments are also modifiers.

# Extended Help
If you still want to use the basic constructor `Object(tag, description, modifiers)`:
*don't*! If this package is complete, this should never be necessary. If you still think
it necessary, consider submitting a new issue on [GitHub](https://github.com/mushunrek/PoVRay.jl).

Still not deterred? You can force the creation of a new Object by using the 
constructor 

    Object(tag, descriptors, modifiers, force_creation=true)
"""
struct PoVRayObject <: AbstractPoVRay
    tag::String
    descriptors::Vector{AbstractPoVRay}
    modifiers::Dict{Symbol, AbstractPoVRay}

    function PoVRayObject(tag, descriptors, modifiers; force_creation=false)
        if force_creation == true
            return new(tag, descriptors, modifiers)
        end
        error("Please refer to `?BasicObject` on how to correctly implement a new BasicObject")
    end
end

Base.getindex(o::PoVRayObject, modif::Symbol) = o.modifiers[modif]
function Base.setindex!(o::PoVRayObject, p::AbstractPoVRay, modif::Symbol)
    o.modifiers[modif] = p
end
function Base.deepcopy(object::PoVRayObject)
    PoVRayObject(
        object.tag,
        object.descriptors,
        object.modifiers,
        force_creation=true
    )
end

function ElementaryObjects.construct_pov(object::PoVRayObject)
    pov = "$(object.tag){\n\t"
    for d in object.descriptors
        pov *= replace(
                    construct_pov(d),
                    "\n" => "\n\t"
                )
    end
    for m in object.modifiers
        if m.first == :scale
            pov *= "scale $(construct_pov(m.second))\n\t"
        elseif m.first == :translate
            pov *= "translate $(construct_pov(m.second))\n\t"
        elseif m.first == :rotate 
            pov *= "rotate $(construct_pov(m.second))\n\t"
        else
            pov *= "$(construct_pov(m.second))\n\t"
        end
    end
    return pov * "\n}\n"
end

"""
    Sphere(position, radius) -> PoVRayObject

Creates a sphere at `position` with specified `radius`.

# Example
s = Sphere([0.0, 0.0, 0.0], 2)
s[:scale] = 0.5
s[:translate] = [1, 4.2, -3]
"""
function Sphere(position, radius)
    PoVRayObject(
        "sphere", 
        [PoVRayPoint(position), PoVRayNumber(radius)], 
        Dict(), 
        force_creation=true
    )
end

function Pigment(rgbft::RGBFT)
    PoVRayObject(
        "pigment",
        [rgbft],
        Dict(),
        force_creation=true
    )
end

function color!(object::PoVRayObject, rgbft::RGBFT)
    object[:pigment] = Pigment(rgbft)
    return nothing
end

function Colored(object::PoVRayObject, rgbft::RGBFT)
    colored = deepcopy(object)
    colored[:pigment] = Pigment(rgbft)
    return colored
end

function Union(objects::Vector{PoVRayObject})
    PoVRayObject(
        "union",
        objects,
        Dict(),
        force_creation=true
    )
end

"""
struct Sphere <: BasicShape
    position::PoVRayPoint
    radius::Float64

    Sphere(position, radius) = new(PoVRayPoint(position), radius)
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
    (construct_pov(s.position))
    (s.radius)
}"
end

function ElementaryObjects.construct_pov(cobject::Colored{T}) where T <: Object
    str = construct_pov(cobject.object)
    index = findlast("}", str)
    return str[1:collect(index)[1]-1] * 
"   pigment{
        (construct_pov(cobject.rgbft))
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
"""

end