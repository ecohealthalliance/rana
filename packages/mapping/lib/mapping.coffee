Mapping = {}

Mapping.utmFromLonLat = (lon, lat) ->
  zone = Mapping.lon2UTMZone lon
  utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
  lonlatProj = proj4.Proj('WGS84')
  utm = proj4.transform(lonlatProj, utmProj, [lon, lat])
  { easting: utm.x, northing: utm.y, zone: zone }

Mapping.lonLatFromUTM = (easting, northing, zone) ->
  utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
  lonlatProj =  proj4.Proj('WGS84')
  lonLat = proj4.transform utmProj, lonlatProj, [easting, northing]
  { lon: lonLat.x, lat: lonLat.y }

Mapping.lon2UTMZone = (lon) ->
  Math.floor(((lon + 180) / 6) %% 60) + 1

Mapping.decimal2MinSec = (decimal) ->
  degrees = Math.floor(decimal)
  minutes = Math.floor 60 * (decimal - degrees)
  seconds = 3600 * (decimal - degrees - minutes / 60)

  degrees: degrees
  minutes: minutes
  seconds: seconds

Mapping.minSec2Decimal = (degrees, min, sec) ->
  degrees + min / 60 + sec / 3600
