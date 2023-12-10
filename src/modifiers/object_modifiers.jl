module ObjectModifiers
    using ReusePatterns

    using ...AbstractSuperType
    using ..Modifiers

    export ObjectModifier
    export Transformation, Scaling, Rotation, Translation, MatrixTransformation
    export PlainTexture
    
    @quasiabstract struct ObjectModifier <: AbstractModifier
        tag::Symbol
    end

    @quasiabstract struct Transformation{T<:PoVRayable} <: ObjectModifier
        descriptor::T
    end

    @quasiabstract struct Scaling <: Transformation{Union{Float64, PoVRayPoint}}
        Scaling(s) = new(:scale, s)
    end
    
    @quasiabstract struct Rotation <: Transformation{PoVRayPoint} 
        Rotation(r) = new(:rotate, r)
    end
    
    @quasiabstract struct Translation <: Transformation{PoVRayPoint} 
        Translation(t) = new(:translate, t)
    end
    
    @quasiabstract struct MatrixTransformation <: Transformation{PoVRayMatrix} 
        MatrixTransformation(m) = new(:matrix, m)
    end
    
    function AbstractSuperType.construct_povray(t::Transformation{T}) where T <: PoVRayable
        "$(t.tag) $(construct_povray(t.descriptor))"
    end

    #include("textures.jl")
    #using .TextureModifiers, .Textures
end