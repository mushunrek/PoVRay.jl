module PoVRay

include("type_hierarchy.jl")
using .Types
include("colors.jl")
using .PoVRayColors
include("modifiers/modifiers.jl")
using .Modifiers
include("cameras.jl")
using .Cameras
include("objects.jl")
using .Objects

export render
export Types

export Camera, LightSource
export Sphere, Plane
export Pigment 
export PoVRayColor


"""
include("elementary_objects.jl")
#include("modifiers.jl")
include("objects.jl")
include("cameras.jl")
include("lights.jl")

using .ElementaryObjects, .Objects, .Cameras, .Lights

export AbstractPoVRay, PoVRayNumber, PoVRayPoint
export RGBFT
export PoVRayObject
export Sphere 
export Colored, color!
export Union
export Camera, LookAtCamera
export Light, PointLight
export construct_pov, render
"""

"""
include("abstract_supertype.jl")
include("modifiers/modifiers.jl")
include("objects.jl")
using .AbstractSuperType, .Modifiers, .Objects

export AbstractPoVRay, PoVRayable
export PoVRayObject, PoVRayModifier

using ReusePatterns

export Sphere
"""



function render(
            objs::Types.Object...; 
            camera::Camera=Camera(location=[0,5,0], look_at=[0,0,0]), 
            light::LightSource=LightSource([0.0, 3.0, 0.0], "white"),
            include::Vector{String}=["colors.inc"],
            pov_path::String="/tmp/auto_generated.pov", 
            ini_path::String="/tmp/auto_generated.ini",
            output_path::String="/tmp/auto_generated.png",
            width=1000, height=500
        )
    str = "#version 3.7;
global_settings{assumed_gamma 1.0}\n\n
"

    for inc in include
        str *= "#include \"$inc\"\n"
    end

    str *= construct_povray(camera) * "\n"
    str *= construct_povray(light) * "\n"

    str *= construct_povray(objs...) * "\n"


    io = open(pov_path, "w")
    write(io, str)
    close(io)

    open(ini_path, "w") do f
        write(f, "
Width=$width
Height=$height

Antialias=On

Input_File_Name=$pov_path
Output_File_Name=$output_path
"
)
    end

    run(`povray -D $ini_path`)
end


end
