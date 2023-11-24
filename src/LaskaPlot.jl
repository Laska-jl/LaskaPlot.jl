module LaskaPlot

const standardcol = "#4C2C69"::String

using LaskaCore
using MakieCore
using Makie

# Visualization
include("visualize/recipes/frequencyrecipe.jl")
export frequencybydepthplot
end
