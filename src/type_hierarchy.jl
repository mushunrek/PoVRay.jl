module Types

using ReusePatterns

export construct_povray

PoVRayFloat = Float64
PoVRayVector = Vector{PoVRayFloat}
PoVRayLiteral = Union{PoVRayFloat, PoVRayVector}

@quasiabstract struct Keyword 
    tag::Symbol
end

AbstractPoVRay = Union{PoVRayLiteral, Keyword}

construct_povray(::AbstractPoVRay) = @assert(false, "This method has to be implemented for every user-end subtype of `PoVRay`")
function construct_povray(x::AbstractPoVRay...)
    join(
        construct_povray.(x),
        "\n"
    )
end
construct_povray(x::Vector{<:AbstractPoVRay}) = construct_povray(x...)
Base.show(io::IO, x::Keyword) = print(io, construct_povray(x))

construct_povray(f::PoVRayFloat) = "$f"
construct_povray(v::PoVRayVector) = "<" * join(v, ", ") * ">"

@quasiabstract struct SimpleKeyword <: Keyword end

construct_povray(kw::SimpleKeyword) = "$(kw.tag)"

@quasiabstract struct DoubleKeyword <: Keyword 
    descriptor::PoVRayLiteral
end

construct_povray(kw::DoubleKeyword) = "$(kw.tag) " * construct_povray(kw.descriptor)

@quasiabstract struct ComplexKeyword{N, T<:AbstractPoVRay} <: Keyword
    descriptors::Vector{<:T}
end

function construct_povray(kw::ComplexKeyword)
    povray = "$(kw.tag){\n\t"
    povray *= replace(construct_povray(kw.descriptors), "\n" => "\n\t")
    povray *= "\n}"
    return povray
end

@quasiabstract struct ModifiableKeyword{N, T<:AbstractPoVRay, S<:Keyword} <: ComplexKeyword{N, T}
    modifiers::Vector{<:S}
end

function construct_povray(kw::ModifiableKeyword)
    povray = "$(kw.tag){\n\t"
    povray *= replace(construct_povray(kw.descriptors), "\n" => "\n\t")
    if length(kw.modifiers) > 0
        povray *= "\n\t"
        povray *= replace(construct_povray(kw.modifiers), "\n" => "\n\t")
    end
    povray *= "\n}"
    return povray
end

@quasiabstract struct SimpleModifier <: SimpleKeyword end

@quasiabstract struct DoubleModifier <: DoubleKeyword end

@quasiabstract struct ComplexModifier{N, T} <: ComplexKeyword{N, T} end

@quasiabstract struct ModifiableModifier{N, T, S} <: ModifiableKeyword{N, T, S} end

Modifier = Union{SimpleModifier, DoubleModifier, ComplexModifier, ModifiableModifier}

@quasiabstract struct Pattern{N, T, S<:Modifier} <: ModifiableModifier{N, T, S} end

#@quasiabstract struct Object{N, T, S<:Modifier} <: ModifiableKeyword{N, T, S} end 
@quasiabstract struct Object{N, T} <: ModifiableKeyword{N, T, Modifier} end 


end