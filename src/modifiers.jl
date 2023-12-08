module Modifiers

using ..ElementaryObjects
using ..Objects

export PoVRayModifier
export Scaling, Translation, Rotation
export Pigment

abstract type AbstractPoVRayModifier <: AbstractPoVRay end
abstract type AbstractTransformation <: AbstractPoVRayModifier end
abstract type AbstractSurfaceModifier <: AbstractPoVRayModifier end

struct Scaling <: AbstractTransformation
    scaling::Union{PoVRayNumber, PoVRayPoint}
end

struct Translation <: AbstractTransformation
    translation::PoVRayPoint
end

struct Rotation <: AbstractTransformation
    rotation::PoVRayPoint
end

ElementaryObjects.construct_pov(s::Scaling) = "scale $(construct_pov(s))"
ElementaryObjects.construct_pov(t::Translation) = "translate $(construct_pov(t))"
ElementaryObjects.construct_pov(r::Rotation) = "rotate $(construct_pov(r))"

struct KeywordModifier <: AbstractPoVRayModifier
    keyword::String 
end

ElementaryObjects.construct_pov(kwm::KeywordModifier) = kwm.keyword

struct Pigment{N} <: AbstractSurfaceModifier
    items::NTuple{N, AbstractPoVRay}
end

function ElementaryObjects.construct_pov(pigment::Pigment)
    """pigment{
    $(join(construct_pov.(pigment.items), "\n\t"))
}"""
end

Pigment(rgbft::RGBFT) = Pigment{1}((rgbft,))

end