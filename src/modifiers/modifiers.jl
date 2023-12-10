module Modifiers

using ReusePatterns

using ..AbstractSuperType

export AbstractModifier
export Transformation, Scaling, Rotation, Translation, MatrixTransformation

abstract type AbstractModifier <: AbstractPoVRay end


include("patterns.jl")
using .Patterns, .PatternModifiers

include("object_modifiers.jl")
using .ObjectModifiers

"""
@quasiabstract struct Transformation{T<:PoVRayable} <: ObjectModifier
    descriptor::T
end

@quasiabstract struct SpecificTexture{T<:TextureModifier} <: AbstractModifier
    modifiers::Union{T, Transformation}
end
@quasiabstract struct Texture <: AbstractModifier
    modifiers::Vector{Union{SpecificTexture, Transformation}}
    Texture(modifiers::Union{SpecificTexture, Transformation}...) = new(:texture, [m for m in modifiers])
end



@quasiabstract struct Pigment <: SpecificTexture{PigmentModifier} 
    Pigment(modifiers::PigmentModifier...) = new(:pigment, [m for m in modifiers])
end
@quasiabstract struct Normal <: SpecificTexture{NormalModifier} 
    Normal(modifiers::NormalModifier...) = new(:normal, [m for m in modifiers])
end 
@quasiabstract struct Finish <: SpecificTexture{FinishModifier} 
    Finish(modifiers::FinishModifier...) = new(:finish, [m for m in modifiers])
end



function AbstractSuperType.construct_povray(texture::Texture)
    povray = "(t.tag){ "
    if length(texture.modifiers) > 0
        povray *= "\n\t"
        povray *= replace(
                        join( texture.modifiers, "\n" ),
                        "\n" => "\n\t"
                    )
        povray *= "\n"
    end
    povray *= "}"
    return povray
end


"""

"""
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

ElementaryObjects.construct_pov(s::Scaling) = "scale (construct_pov(s))"
ElementaryObjects.construct_pov(t::Translation) = "translate (construct_pov(t))"
ElementaryObjects.construct_pov(r::Rotation) = "rotate (construct_pov(r))"

struct KeywordModifier <: AbstractPoVRayModifier
    keyword::String 
end

ElementaryObjects.construct_pov(kwm::KeywordModifier) = kwm.keyword

struct Pigment{N} <: AbstractSurfaceModifier
    items::NTuple{N, AbstractPoVRay}
end
"""

end