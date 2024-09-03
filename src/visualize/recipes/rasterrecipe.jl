#-----------
# Rasterplot
#-----------


Makie.@recipe(RasterPlot, cluster) do scene
    Makie.Attributes(
        # Specific attributes
        convert_samplerate=true,
        samplerate=nothing,
        # Scatter attributes
        color=theme(scene, :markercolor),
        cycle=[:color],
        marker=:vline,
        markersize=5,
        markerspace=:pixel,
        strokewidth=0,
        strokecolor=:black,
        glowwidth=0,
        glowcolor=(:black, 0),
        rotation=Makie.Billboard(0.0f0),
        transform_marker=false,
        # Color attributes
        colormap=:viridis,
        colorscale=identity,
        colorrange=nothing,
        lowclip=nothing,
        highclip=nothing,
        alpha=1.0,
        #Generic attributes
        visible=true,
        overdraw=false,
        transparency=false,
        fxaa=true,
        inspectable=true,
        depth_shift=0.0f0,
        model=nothing,
        space=:data
    )
end

function Makie.plot!(plt::RasterPlot)
    p = plt[:cluster]

    if !(p[] isa LaskaCore.RelativeCluster)
        throw(ArgumentError("Type of cluster must be LaskaCore.RelativeCluster, not $(typeof(p[]))"))
    end

    spikes::Makie.Observable{Vector{Vector{Float32}}} = Makie.Observable(spiketimes(p[]))
    if isnothing(plt[:samplerate][])
        plt[:samplerate][] = LaskaCore.samplerate(LaskaCore.spiketimes(p[]))
    end
    if plt[:convert_samplerate][]
        conversion_factor::Float32 = 1 / (plt[:samplerate][] * 0.001)
        for i in eachindex(spikes[])
            spikes[][i] .*= conversion_factor
        end
    end

    plt[:color][] = typeof(plt[:color][]) <: AbstractVector ? Iterators.cycle(plt[:color][]) : Iterators.cycle([plt[:color][],])

    function update_plot!(plt, spikes)
        for (i, c) in zip(eachindex(spikes[]), plt[:color][])
            scatter!(
                plt,
                spikes[][i],
                fill(i - 1, length(spikes[][i])),
                # Scatter attributes
                color=c,
                cycle=plt[:cycle][],
                marker=plt[:marker][],
                markersize=plt[:markersize][],
                markerspace=plt[:markerspace][],
                strokewidth=plt[:strokewidth][],
                strokecolor=plt[:strokecolor][],
                glowwidth=plt[:glowwidth][],
                glowcolor=plt[:glowcolor][],
                rotation=plt[:rotation][],
                transform_marker=plt[:transform_marker][],
                # Color Attributes
                colormap=plt[:colormap][],
                colorscale=plt[:colorscale][],
                colorrange=plt[:colorrange][],
                lowclip=plt[:lowclip][],
                highclip=plt[:highclip][],
                alpha=plt[:alpha][],
                # Generic attributes
                visible=plt[:visible][],
                overdraw=plt[:overdraw][],
                transparency=plt[:transparency][],
                fxaa=plt[:fxaa][],
                inspectable=plt[:inspectable][],
                depth_shift=plt[:depth_shift][],
                model=plt[:model][],
                space=plt[:space][]
            )

        end

    end
    update_plot!(plt, spikes)

end
