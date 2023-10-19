module Cameras

using ..ElementaryObjects
using ..Points

export Camera, LookAtCamera

abstract type Camera <: POV end

struct LookAtCamera <: Camera
    position::Point3D
    look_at::Point3D

    function LookAtCamera(position, look_at)
        new(Point3D(position), Point3D(look_at))
    end
end

LookAtCamera() = LookAtCamera( [0.0, 5.0, 0.0], [0.0, 0.0, 0.0] )


function ElementaryObjects.construct_pov(camera::LookAtCamera)
    "camera{
        orthographic
        sky <0, 0, 1>
        location $(construct_pov(camera.position))
        look_at $(construct_pov(camera.look_at))
    }"
end





end