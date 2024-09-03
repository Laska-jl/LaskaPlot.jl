# """
#
#     frequencybydepthplot(experiment::RelativeSpikes, depths, period)
#     frequencybydepthplot!(ax, experiment::RelativeSpikes, depths, period)
#
# Makie plot recipe for relative frequency by depth.
#
# Requires an `experiment::RelativeSpikes`, number of `depths` and `period` for length of bins when calculating frequency.
#
# ## Attributes
#
# ### Plot-specific Attributes
#
# - `customx` A vector of custom x values. Should be of the same length as the number of frequency bins.
# - `stimlines::Bool`: Should lines at each stimulation time (as specified when creating the `RelativeSpikes`-struct) be included?
#     - `stimlinecolor`
#     - `stimlinealpha`
#     - `stimlinewidth`
#
# ### General 'lines' attributes
#
# - `color`
# - `linestyle`
# - `linewidth`
# - `colormap`
# - `colorscale`
# - `colorrange`
# - `nan_color`
# - `lowclip`
# - `highclip`
# - `alpha`
# - `visible`
# - `overdraw`
# - `fxaa`
# - `inspectable`
# - `depth_shift`
# - `space`
# """
# Makie.@recipe(FrequencyByDepthPlot, experiment, depths, period) do scene
#     Makie.Attributes(
#         stimlines=true,
#         stimlinecolor=:gray,
#         stimlinealpha=0.7,
#         stimlinewidth=1.5,
#         customx=nothing,
#         color=LaskaPlot.standardcol,
#         linestyle=:solid,
#         linewidth=2.0,
#         colormap=:viridis,
#         colorscale=identity,
#         colorrange=(0.0, 2.5),
#         nan_color="#ffffff",
#         lowclip=nothing,
#         highclip=nothing,
#         alpha=1.0,
#         visible=true,
#         overdraw=false,
#         fxaa=true,
#         inspectable=true,
#         depth_shift=0.0f0,
#         space=:data,
#     )
# end
#
#
# function Makie.plot!(plt::FrequencyByDepthPlot)
#     if !(plt[:experiment][] isa LaskaCore.RelativeSpikes)
#         throw(ArgumentError("Type of exp must LaskaCore.RelativeSpikes, not $(typeof(plt[:experiment][]))"))
#     end
#
#     lins = Makie.Observable(Vector{Vector{Float64}}(undef, 0))
#
#     function update_plot(plt, linesvec)
#         exp = plt.experiment
#
#         depths = plt.depths
#
#         period = plt.period
#
#         alldepths = info.(clustervector(exp[]), "depth")
#
#         maxdepth = maximum(alldepths)
#
#         spikes = spikesatdepth(exp[], (0.0, maxdepth))
#
#         mintime = LaskaCore.roundup(LaskaCore.minval(spikes), period[])
#         maxtime = LaskaCore.roundup(LaskaCore.maxval(spikes), period[])
#
#         steps = mintime:period[]:maxtime
#
#         empty!(linesvec[])
#
#         depthinterval = maxdepth / depths[]
#
#
#         for i in depths[]:-1:1
#             current_depth = (depthinterval * (i - 1), depthinterval * i)
#             push!(
#                 lins[],
#                 LaskaStats.relativefrequency(LaskaCore.spikesatdepth(exp[], current_depth), steps)
#             )
#         end
#
#         max_response = ceil(LaskaCore.maxval(lins[], 0.0)) + abs(LaskaCore.minval(lins[], 0.0))
#         for i in length(lins[]):-1:1
#             lins[][i] .+= ((i - 1) * max_response)
#         end
#
#         for i in eachindex(lins[])
#             lines!(
#                 plt,
#                 lins[][i],
#                 color=plt.color[],
#                 linestyle=plt.linestyle[],
#                 linewidth=plt.linewidth[],
#                 colormap=plt.colormap[],
#                 colorscale=plt.colorscale[],
#                 colorrange=plt.colorrange[],
#                 nan_color=plt.nan_color[],
#                 lowclip=plt.lowclip[],
#                 highclip=plt.highclip[],
#                 alpha=plt.alpha[],
#                 visible=plt.visible[],
#                 overdraw=plt.overdraw[],
#                 fxaa=plt.fxaa[],
#                 inspectable=plt.inspectable[],
#                 depth_shift=plt.depth_shift[],
#                 space=plt.space[],
#             )
#         end
#
#     end
#
#
#     Makie.Observables.onany(update_plot, plt)
#     update_plot(plt, lins)
#
#
# end
#
#
# # function update_plot(plt)
# #     p = plt.experiment
# #
# #     depths = plt.depths
# #
# #     period = plt.period
# #     alldepths::Vector{Float64} = info.(clustervector(p[]), "depth")
# #     maxdepth::Float64 = maximum(alldepths)
# #
# #     steps::StepRange = (((LaskaCore.roundup(
# #         LaskaCore.minval(spikesatdepth(p[], (0.0, maxdepth))),
# #         period[],
# #     )-period[]):period[]:LaskaCore.roundup(
# #         LaskaCore.maxval(spikesatdepth(p[], (0.0, maxdepth))),
# #         period[],
# #     ))[2:end])
# #     depthinterval = maxdepth / depths[]
# #     actualdepths::Vector{Int64} = Int64[]
# #
# #     for d = depths[]:-1:1
# #         if length(alldepths[(d-1)*depthinterval.<=alldepths.<d*depthinterval]) != 0
# #             push!(actualdepths, d)
# #         end
# #     end
# #
# #     empty!(lins[])
# #
# #     for i in eachindex(actualdepths)
# #         dpth::NTuple{2,Float64} =
# #             ((actualdepths[i] - 1) * depthinterval, actualdepths[i] * depthinterval)
# #         push!(
# #             lins[],
# #             LaskaStats.relativefrequency(LaskaCore.spikesatdepth(p[], dpth), steps),
# #         )
# #     end
# #     maxresp = ceil(LaskaCore.maxval(lins[], 0.0) + abs(LaskaCore.minval(lins[], 0.0)))
# #     for i = length(lins[]):-1:1
# #         lins[][i] .+= (((i - 1) * maxresp))
# #     end
# #
# #     if isnothing(plt.color[])
# #         plt.color[] = standardcol
# #     end
# #     if isnothing(plt[:customx][])
# #         plt[:customx][] = collect(
# #             LaskaCore.roundup(
# #                 LaskaCore.minval(spikesatdepth(p[], (0.0, maxdepth))),
# #                 period[],
# #             ):period[]:LaskaCore.roundup(
# #                 LaskaCore.maxval(spikesatdepth(p[], (0.0, maxdepth))),
# #                 period[],
# #             )
# #         )
# #
# #     end
# #
# #     if plt[:stimlines][]
# #         stimT = collect(values(stimtimes(p[])))
# #         Makie.vlines!(
# #             plt,
# #             stimT,
# #             color=plt[:stimlinecolor][],
# #             alpha=plt[:stimlinealpha][],
# #             linewidth=plt[:stimlinewidth][],
# #         )
# #     end
# #     for i in eachindex(lins[])
# #         Makie.lines!(
# #             plt,
# #             plt[:customx][][1:length(lins[][i])],
# #             lins[][i],
# #             color=plt.color[],
# #             linestyle=plt.linestyle[],
# #             linewidth=plt.linewidth[],
# #             colormap=plt.colormap[],
# #             colorscale=plt.colorscale[],
# #             colorrange=plt.colorrange[],
# #             nan_color=plt.nan_color[],
# #             lowclip=plt.lowclip[],
# #             highclip=plt.highclip[],
# #             alpha=plt.alpha[],
# #             visible=plt.visible[],
# #             overdraw=plt.overdraw[],
# #             fxaa=plt.fxaa[],
# #             inspectable=plt.inspectable[],
# #             depth_shift=plt.depth_shift[],
# #             space=plt.space[],
# #         )
# #     end
# #
# # end
