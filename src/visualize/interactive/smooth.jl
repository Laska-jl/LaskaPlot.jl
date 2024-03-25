
function interactivefouriersmooth(V::AbstractVector{T},
    σ=1.0,
    m=2,
    σ_range=1:0.1:250,
    m_range=2:2:50) where {T}
    fig = Figure()
    ax = Axis(fig[1, 1])
    sl_σ = Slider(fig[1, 2], range=σ_range, startvalue=σ)
    sl_m = Slider(fig[1, 3], range=m_range, startvalue=m)
    smoothed = lift(sl_σ, sl_m) do sigma, m
        fouriersmooth(V, sigma.value, m.value)
    end
    MakieCore.scatter!(ax, smoothed)
end
