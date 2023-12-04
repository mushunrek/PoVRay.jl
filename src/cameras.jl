module Cameras

using ..ElementaryObjects

export Camera, LookAtCamera

abstract type Camera <: AbstractPoVRay end

struct LookAtCamera <: Camera
    position::PoVRayPoint
    look_at::PoVRayPoint

    function LookAtCamera(position, look_at)
        new(PoVRayPoint(position), PoVRayPoint(look_at))
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