
function interactivefouriersmooth(V::AbstractVector{T},
    σ=1.0,
    m=2,
    σ_range=1:0.1:250,
    m_range=2:2:50;
    plotoriginal=true) where {T}
    fig = Figure()
    sl = SliderGrid(
        fig[2, 1],
        (label="σ", range=σ_range, startvalue=σ),
        (label="m", range=m_range, startvalue=m)
    )
    smoothed = lift(sl.sliders[1].value, sl.sliders[2].value) do sigma, m
        LaskaStats.fouriersmooth(V, sigma, m)
    end
    ax = Axis(
        fig[1, 1]
    )
    if plotoriginal
        lines!(V, alpha=0.3, color=:black)
    end
    lines!(ax, smoothed)
    fig
end
