module Lights

using ..ElementaryObjects
using ..Points
using Colors

export Light, PointLight

abstract type Light <: POV end

struct PointLight <: Light 
    position::Point 
    point_at::Point
    PointLight(position, point_at) = new(Point(position), Point(point_at))
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