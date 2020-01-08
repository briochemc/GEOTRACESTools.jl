"""
    TracerRatio(tracer1, tracer2)

Plots a horizontal slice of tracer `x` at depth `depth`.
"""
@userplot TracerRatio
@recipe function f(p::TracerRatio)
    tracer1, tracer2 = p.args
    xunit = string(unit(x[1]))
    x3D = rearrange_into_3Darray(ustrip.(x), grd)
    lon, lat = grd.lon .|> ustrip, grd.lat .|> ustrip
    iz = findfirst(ustrip.(grd.depth) .≥ ustrip(upreferred(depth)))
    isnothing(iz) && (iz = length(grd.depth))
    @series begin
        seriestype := :contourf
        xlabel := "Longitude"
        ylabel := "Latitude"
        colorbar_title := xunit
        lon, lat, view(x3D, :, :, iz)
    end
end
