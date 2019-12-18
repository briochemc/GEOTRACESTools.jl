
"""
    dummy_cruise_track(; departure=sydney(), arrival=losangeles())

Returns a dummy cruise track going roughly from `departure` to `arrival` as (lat,lon) tuples.
Default track departs in Sydney and arrives in Los Angeles.

`
"""
function dummy_cruise_track(; departure=sydney(), arrival=losangeles(), n=20)
    lat = collect(range(departure[1], arrival[1], length=n)) .+ randn(n)
    lon = collect(range(departure[2], arrival[2], length=n)) .+ randn(n)
    date = [now() - Day(k) for k in 0:n-1]
    return CruiseTrack("Dummy Cruise Track", lon, lat, date)
end

sydney() = (-33.847927, 150.6517884)

losangeles() = (34.0201613, 360.0 - 118.6919188)

export dummy_cruise_track


