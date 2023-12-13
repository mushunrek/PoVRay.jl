module Objects

using ReusePatterns

using ..Types 
using ..PoVRayColors

export LightSource
export Sphere, Plane



@quasiabstract struct LightSource <: Types.Object{1, Union{Types.PoVRayVector, PoVRayColor}}
    function LightSource(location, color="white"; kwmodifiers...)
        modifiers = Vector{Types.Modifier}()
        for (key, value) in kwmodifiers
            if key in 
        end
        new(
            :light_source, 
            Vector{Union{Types.PoVRayVector, PoVRayColor}}(
                [Float64.(location), PoVRayColor(color)]
            ), 
            Vector{Types.Modifier}([m for m in modifiers])
        )
    end
end

@quasiabstract struct FiniteSolidPrimitive{N, T} <: Types.Object{N, T} end
@quasiabstract struct InfiniteSolidPrimitive{N, T} <: Types.Object{N, T} end
@quasiabstract struct CSG{N, T} <: Types.Object{N, T} end

@quasiabstract struct Sphere <: FiniteSolidPrimitive{2, Types.PoVRayLiteral}
    function Sphere(position, radius, modifiers::Types.Modifier...)
        new(
            :sphere, 
            Vector{Types.PoVRayLiteral}([Float64.(position), radius]), 
            Vector{Types.Modifier}([m for m in modifiers])
        )
    end
end

@quasiabstract struct Plane <: InfiniteSolidPrimitive{2, Types.PoVRayLiteral}
    function Plane(normal, distance, modifiers...)
        new(
            :plane, 
            Vector{Types.PoVRayLiteral}([Float64.(normal), Float64(distance)]), 
            Vector{Types.Modifier}([m for m in modifiers])
        )
    end
end

function Types.construct_povray(plane::Plane)
    povray = "plane{" * join(construct_povray.(plane.descriptors), ", ")
    if length(plane.modifiers) > 0
        povray *= "\n\t"
        povray *= replace(
            construct_povray(plane.modifiers),
            "\n" => "\n\t"
        )
        povray *= "\n"
    end
    povray *= "}"
    return povray
end

"""
using ..AbstractSuperType, ..Modifiers

export PoVRayObject
export Sphere
export Plane 
export CSGUnion

@quasiabstract struct PoVRayObject{N} <: AbstractPoVRay
    tag::Symbol
    descriptors::NTuple{N, PoVRayable}
    modifiers::Vector{AbstractModifier}
end

function AbstractSuperType.construct_povray(object::PoVRayObject)
    povray = "(object.tag){\n\t"
    povray *= replace(
                join(object.descriptors, "\n"),
                "\n" => "\n\t"
                )
    if length(object.modifiers) > 0
        povray *= "\n\t"
        povray *= replace(
                        join(object.modifiers, "\n"),
                        "\n"  => "\n\t"
                    )
    end
    povray *= "\n}"
    return povray
end

function deepcopy(object::T) where T <: PoVRayObject
    T(
        ( getfield(object, f) for f in fieldnames(T) )...
    )
end

modify!(object::PoVRayObject, modifier::AbstractModifier) = append!(object.modifiers, modifier)
scale!(object::PoVRayObject, s) = modify!(object, Scaling(s))
rotate!(object::PoVRayObject, r) = modify!(object, Rotation(r))
translate!(object::PoVRayObject, t) = modify!(object, Translation(t))
matrix_transform!(object::PoVRayObject, m) = modify!(object, MatrixTransformation(m))

function scale(object, ss)
    objects = [ deepcopy(object) for _ in ss ]
    scale!.(objects, ss)
    return objects
end

function rotate(object, rs)
    objects = [ deepcopy(object) for _ in rs ]
    rotate!.(objects, rs)
    return objects
end

function translate(object, ts)
    objects = [ deepcopy(object) for _ in ts ]
    translate!.(objects, ts)
    return objects
end

function matrix_transform(object, ms)
    objects = [ deepcopy(object) for _ in ms ]
    translate!.(objects, ts)
    return objects
end


module FiniteSolidPrimitives 
    using ReusePatterns

    using ...AbstractSuperType
    using ..Objects

    export Sphere

    @quasiabstract struct FiniteSolidPrimitive{N} <: PoVRayObject{N} end

    @quasiabstract struct Sphere <: FiniteSolidPrimitive{3} 
        Sphere(position, radius, modifiers...) = new(:sphere, (PoVRayPoint(position), radius), [m for m in modifiers])
    end

end

module InfiniteSolidPrimitives
    using ReusePatterns

    using ...AbstractSuperType
    using ..Objects

    export Plant

    @quasiabstract struct InfiniteSolidPrimitive{N} <: PoVRayObject{N} end

    @quasiabstract struct Plane <: InfiniteSolidPrimitive{2}
        Plane(normal, distance, modifiers...) = new(:plane, (PoVRayPoint(normal), distance), [m for m in modifiers])
    end

end


module CSGs 
    using ReusePatterns
    using ..Objects

    export CSGUnion

    @quasiabstract struct CSG{N} <: PoVRayObject{N} end

    @quasiabstract struct CSGUnion{N} <: CSG{N} 
        CSGUnion(objects, modifiers...) = new{length(objects)}(:union, Tuple(objects), [m for m in modifiers])
    end
end


using .FiniteSolidPrimitives, .InfiniteSolidPrimitives, .CSGs
"""
end