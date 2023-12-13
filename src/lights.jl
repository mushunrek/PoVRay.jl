module Lights

using ..Types
using Colors

export Light, PointLight

abstract type Light <: AbstractPoVRay end

struct PointLight <: Light 
    position::PoVRayPoint 
    point_at::PoVRayPoint
    PointLight(position, point_at) = new(PoVRayPoint(position), PoVRayPoint(point_at))
end

function ElementaryObjects.construct_pov(light::PointLight)
    "light_source{
        $(construct_pov(light.position))
        color White
        parallel
        point_at $(construct_pov(light.point_at))
    }"
end

end