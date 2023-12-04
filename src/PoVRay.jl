module PoVRay

include("elementary_objects.jl")
include("points.jl")
include("objects.jl")
include("cameras.jl")
include("lights.jl")

using .ElementaryObjects, .Points, .Objects, .Cameras, .Lights 

export Point3D
export RGBFT
export Object, BasicObject
export Sphere, BasicSphere 
export Colored
export CSGUnion
export Camera, LookAtCamera
export Light, PointLight
export construct_pov, render


function render(
            objs::Object, 
            camera::Camera=LookAtCamera(), 
            light::Light=PointLight([0.0, 2.0, 0.0], [0.0, 0.0, 0.0]);
            include::Vector{String}=["colors.inc"],
            pov_path::String="/tmp/auto_generated.pov", 
            ini_path::String="/tmp/auto_generated.ini",
            output_path::String="/tmp/auto_generated.png"
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

    open(ini_path, "w") do f
        write(f, "
Width=1000
Height=500

Antialias=On

Input_File_Name=$pov_path
Output_File_Name=$output_path
"
)
    end

    run(`povray -D $ini_path`)
end


end
