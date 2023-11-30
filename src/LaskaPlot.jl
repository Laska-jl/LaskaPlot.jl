module LaskaPlot

const standardcol = "#4C2C69"::String

using Reexport
@reexport using LaskaCore
@reexport using LaskaStats
using MakieCore
using Makie

# Visualization
include("visualize/recipes/frequencyrecipe.jl")
export frequencybydepthplot

include("visualize/recipes/rasterrecipe.jl")

end
