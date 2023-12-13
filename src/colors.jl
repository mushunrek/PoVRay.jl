module PoVRayColors

using ReusePatterns
import Colors

using ..Types

export PoVRayColor

@quasiabstract struct PoVRayColor <: Types.DoubleKeyword
    function PoVRayColor(rgbft...)
        rgbft = [f for f in rgbft]
        if !(rgbft isa Types.PoVRayVector)
            throw(
                TypeError(
                    :PoVRayColor, "PoVRay.jl", Types.PoVRayVector, typeof(rgbft)
                )
            )
        elseif length(rgbft) != 5
            throw(
                ArgumentError("The inner constructor necessitates 5 arguments: `r, g, b, filter, transmit`")
            )
        end
        new(:rgbft, rgbft)
    end
end

PoVRayColor(r, g, b; filter=1.0, transmit=1.0) = PoVRayColor(r, g, b, filter, transmit)
function PoVRayColor(color::String; filter=0.0, transmit=0.0)
    r, g, b = Colors.color_names[color] ./ 255
    PoVRayColor(
        r, g, b, filter, transmit
    )
end

end
