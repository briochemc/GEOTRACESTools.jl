module GEOTRACESTools

using NCDatasets, Unitful, Dates, Match

"""
    CruiseTrack

Compact type containing cruise track information:
- cruise name
- latitudes
- longitudes
"""
struct CruiseTrack{T,U}
    name::String
    lon::Vector{T}
    lat::Vector{T}
    date::Vector{U}
end

"""
    CruiseTrack(cruise_name)

Construct GEOTRACES `CruiseTrack` from cruise name.
"""
function CruiseTrack(cruise_name)
    ds = Dataset(GEOTRACES_IDP17_DiscreteSamples_path())
    cruise_names = reduce.(string, filter.(!=('\0'), eachcol(ds["metavar1"].var[:,:])))
    idx_cruise = findall(cruise_names .== cruise_name)
    lon = Float64.(ds["longitude"][idx_cruise])
    lat = Float64.(ds["latitude"][idx_cruise])
    date = Dates.DateTime.(ds["date_time"][idx_cruise])
    close(ds)
    isort = sortperm(date)
    return CruiseTrack(cruise_name, lon[isort], lat[isort], date[isort])
end

function Base.show(io::IO, m::MIME"text/plain", ct::CruiseTrack)
    println("GEOTRACES cruise $(ct.name)")
    show(io, m, ["Date" "Longitude" "Latitude" ; ct.date ct.lon ct.lat])
end

GEOTRACES_IDP17_DiscreteSamples_path() = joinpath(homedir(), "Data/GEOTRACES/GEOTRACES_IDP2017_v2 2/discrete_sample_data/netcdf/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.nc")

Base.length(ct::CruiseTrack) = length(ct.lat)

function list_of_cruises()
    ds = Dataset(GEOTRACES_IDP17_DiscreteSamples_path())
    cruise_names = reduce.(string, filter.(!=('\0'), eachcol(ds["metavar1"].var[:,:])))
    close(ds)
    return unique(cruise_names)
end

export CruiseTrack, list_of_cruises

# functions for creating dummy variables for testing
# because programmatic download of GEOTRACES data is forbidden
include("dummy_data.jl")

end # module
