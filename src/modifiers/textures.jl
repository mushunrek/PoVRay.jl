module TextureDescriptors

    using ReusePatterns
    import Colors

    using ...AbstractSuperType
    using ..Modifiers

    export TextureDescriptors
    export PigmentModifier, NormalModifier, FinishModifier

    @quasiabstract struct TextureModifier{N} <: AbstractPoVRay
        tag::Symbol
        descriptors::NTuple{N, PoVRayable}
    end

    @quasiabstract struct PigmentModifier{N} <: TextureModifier{N} end
    @quasiabstract struct NormalModifier{N} <: TextureModifier{N} end
    @quasiabstract struct FinishModifier{N} <: TextureModifier{N} end

    @quasiabstract struct PoVRayColor <: PigmentModifier{1}
        PoVRayColor(r, g, b; filter=0.0, transmit=0.0) = new(:color, (RGBFT(r,g,b, filter=filter, transmit=transmit),))
    end
    function PoVRayColor(rgb::String; filter=0.0, transmit=0.0)
        PoVRayColor(
            (Colors.colors[Colors.color_names[rgb]] ./ 255)...,
            filter=filter,
            transmit=transmit
        )
    end

    @quasiabstract struct TextureDescriptor{N, T<:TextureModifier} <: AbstractPoVRay
        tag::Symbol
        descriptors::NTuple{N, PoVRayable}
        modifiers::Vector{T}
    end


    @quasiabstract struct Pigment{N} <: TextureDescriptor{N, PigmentModifier} end
    @quasiabstract struct Normal{N} <: TextureDescriptor{N, NormalModifier} end
    @quasiabstract struct Finish{N} <: TextureDescriptor{N, FinishModifier} end

end

module Textures

    using ReusePatterns

    using ....AbstractSuperType
    using ...Modifiers
    using ..ObjectModifiers
    using ..TextureDescriptors

    @quasiabstract struct AbstractTexture <: ObjectModifier end

    @quasiabstract struct PlainTexture{N} <: AbstractTexture
        descriptors::NTuple{N, TextureDescriptor}
        modifiers::Vector{Transformation}
        PlainTexture(descriptors, modifiers::Transformation...) = new{length(descriptors)}(:texture, Tuple(descriptors), [m for m in modifiers])
    end

    function AbstractSuperType.construct_povray(texture::PlainTexture)
        povray = "$(texture.tag){\n\t"
        povray *= replace( join( construct_povray.(texture.descriptors), "\n\t" ), "\n" => "\n\t" )
        povray *= replace( join( construct_povray.(texture.modifiers), "\n\t" ), "\n" => "\n\t" )
        povray *= "\n}"
        return povray
    end
    
end
