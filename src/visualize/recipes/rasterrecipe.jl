#-----------
# Rasterplot
#-----------

MakieCore.@recipe(RasterPlot, experiment) do scene
    MakieCore.Attributes(
        color=nothing
    )
end

function MakieCore.plot!(plt::RasterPlot)
    p = plt.experiment

    spikes = Observable(spiketimes(p[]))



end
