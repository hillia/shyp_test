sinon = require('sinon')
should = require('should')
https = require('https')

GeolocationService = require('api/services/GeolocationService')

describe('GeolocationService', ->

  describe('#fetch_coordinates_for_address', ->
    it('returns a geolocation JSON for the given address', (done) ->
      GeolocationService.fetch_coordinates_for_address("Union Square, San Francisco", (geo_data) ->
        geo_data.results[0].formatted_address.should.containEql('Union Square')
        should.exist(geo_data.results[0].geometry.location.lat)
        should.exist(geo_data.results[0].geometry.location.lng)
        done()
      )
    )

    # TODO: See if there's a library to easily stub chunked responses.
    # it('returns an error if geolocation JSON is malformed')
  )
)