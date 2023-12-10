module AbstractSuperType

import StaticArrays: SVector, SMatrix

export AbstractPoVRay, PoVRayable, PoVRayPoint, PoVRayMatrix, RGBFT
export construct_povray

abstract type AbstractPoVRay end
PoVRayPoint = SVector{3, Float64}
PoVRayMatrix = SMatrix{4, 3, Float64, 12}
RGBFT = SVector{5, Float64}

PoVRayable = Union{AbstractPoVRay, Float64, PoVRayPoint, PoVRayMatrix}

function construct_povray(pov::PoVRayable) end

construct_povray(x::Float64) = "$x"
construct_povray(sv::Union{PoVRayPoint, PoVRayMatrix}) = "<$(join(sv, ", "))>"
construct_povray(rgbft::RGBFT) = "rgbft <$(join(rgbft, ", "))>"

end