module ElementaryObjects 

using Colors

export POV, construct_pov
export RGBFT

abstract type POV end

function construct_pov(::POV) end

struct RGBFT <: POV
    color::RGB
    filter::Float64
    transmit::Float64
end

function RGBFT(color::String="white"; filter=0.0, transmit=0.0)
    (color in keys(Colors.color_names)) || error("Unknown Color! For more information, see `Colors.color_names`")
    RGBFT(
        RGB((Colors.color_names[color]./255)...), filter, transmit
    )
end

function construct_pov(rgbft::RGBFT)
    "rgbft<$(rgbft.color.r), $(rgbft.color.g), $(rgbft.color.b), $(rgbft.filter), $(rgbft.transmit)>"
end

end