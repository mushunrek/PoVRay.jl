module Cameras

using ReusePatterns

using ..Types
using ..Modifiers

export Camera, LookAtCamera

@quasiabstract struct CameraType <: Types.SimpleKeyword
    function CameraType(tag)
        if !(tag in [:perspective, :orthographic]) # incomplete!
            throw(
                ArgumentError(tag)
            )
        end
        new(tag)
    end
end

@quasiabstract struct CameraVector <: Types.DoubleKeyword
    function CameraVector(tag, v)
        if !(tag in [:location, :right, :up, :direction, :sky])
            throw(
                ArgumentError("`tag` must be on of `[:location, :right, :up, :direction, :sky]`.")
            )
        end
        if length(v) != 3
            throw(
                ArgumentError("`v` must have length 3")
            )
        end
        new(tag, Float64.(v))
    end
end

CameraDescriptor = Union{CameraType, CameraVector}

@quasiabstract struct SpecificCameraModifier <: Types.DoubleKeyword
    function SpecificCameraModifier(tag, literal)
        if !(tag in [:look_at]) # incomplete!
            throw(
                ArgumentError("`tag` must be on of `[:look_at]`.")
            )
        end
        if literal isa Vector 
            if length(literal) != 3
                throw(
                    ArgumentError("`v` must have length 3")
                )
            end
            literal = Float64.(literal)
        end
        new(tag, literal)
    end
end

CameraModifier = Union{SpecificCameraModifier, Types.Transformation} # incomplete!

@quasiabstract struct Camera <: Types.ModifiableKeyword{1, CameraDescriptor, CameraModifier} 
    function Camera(type=:perspective; location=[0,0,0], kwargs...)
        descriptors = Vector{CameraDescriptor}(
                                [CameraType(type), CameraVector(:location, location)]
                            )
        modifiers = Vector{CameraModifier}()
        for (key, value) in kwargs
            if key in [:right, :up, :direction, :sky]
                append!(descriptors, [CameraVector(key, value)])
            elseif key in [:look_at]    # incomplete!
                append!(modifiers, [SpecificCameraModifier(key, value)])
            end
        end
        new(
            :camera, 
            Vector{CameraDescriptor}(descriptors), 
            Vector{CameraModifier}(modifiers)
        )
    end
end

"""
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
        location (construct_pov(camera.position))
        look_at (construct_pov(camera.look_at))
    }"
end

"""



end