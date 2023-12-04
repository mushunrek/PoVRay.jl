module ElementaryObjects 

using Colors

export AbstractPoVRay, construct_pov
export PoVRayNumber, PoVRayPoint, RGBFT

"""
    AbstractPoVRay

Abstract type for any object to be rendered in some form or another. Any subtype
pf `AbstractPoVRay` must implement the method `construct_pov`.
"""
abstract type AbstractPoVRay end

"""
    construct_pov(::AbstractPoVRay)

Provides the actual interface between Julia and PoVRay. Any `AbstractPoVRay`
object needs a method that produces the corresponding PoVRay code.
"""
function construct_pov(::AbstractPoVRay) end

"""
    PoVRayNumber(f::Number)

An implementation of a number in the PoVRay context.
"""
struct PoVRayNumber <: AbstractPoVRay
    f::Float64
    PoVRayNumber(f) = new(Float64(f))
end

construct_pov(f::PoVRayNumber) = "$(f.f)"

"""
    PoVRayPoint(x, y, z)
    PoVRayPoint(v::Vector)

An implementation of a 3D point in the PoVRay context.
"""
struct PoVRayPoint <: AbstractPoVRay
    x::Float64
    y::Float64
    z::Float64
end

function PoVRayPoint(v::Vector{T}) where T <: Number
    PoVRayPoint(
        Float64.(v)...
    )
end

ElementaryObjects.construct_pov(point::PoVRayPoint) = "<$(point.x), $(point.y), $(point.z)>"


struct RGBFT <: AbstractPoVRay
    color::RGB
    filter::Float64
    transmit::Float64
end

function RGBFT(color::String="white"; filter=0.0, transmit=0.0)
    (color in keys(Colors.color_names)) || error("Unknown Color! For more information, see `Colors.color_names`")
    RGBFT(
        RGB((Colors.color_names[color]./255)...), filter, transmit
    )
end

function construct_pov(rgbft::RGBFT)
    "rgbft<$(rgbft.color.r), $(rgbft.color.g), $(rgbft.color.b), $(rgbft.filter), $(rgbft.transmit)>"
end

end