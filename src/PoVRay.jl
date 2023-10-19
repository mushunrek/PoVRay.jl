module PoVRay

include("elementary_objects.jl")
include("points.jl")
include("objects.jl")
include("cameras.jl")
include("lights.jl")

using .ElementaryObjects, .Points, .Objects, .Cameras, .Lights 

export Point
export RGBFT
export Object
export Sphere 
export Colored
export CSGUnion
export Camera, LookAtCamera
export Light, PointLight
export construct_pov, render


function render(
            objs::Object, 
            camera::Camera, 
            light::Light,
            include::Vector{String}=["colors.inc"],
            pov_path::String="/tmp/auto_generated.pov", 
            ini_path::String="/tmp/auto_generated.ini"
        )
    str = "#version 3.7;
global_settings{assumed_gamma 1.0}\n\n
"

    for inc in include
        str *= "#include \"$inc\"\n"
    end

    str *= construct_pov(camera) * "\n"
    str *= construct_pov(light) * "\n"

    for o in [objs]
        str *= construct_pov(o) * "\n"
    end

    io = open(pov_path, "w")
    write(io, str)
    close(io)

    io = open(ini_path, "w")
    write(io, "Width=1000\nHeight=500\nAntialias=On\n")
    close(io)

    run(`povray $pov_path`)
end


end
