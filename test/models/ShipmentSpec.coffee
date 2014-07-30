wolfpack = require('wolfpack')
sinon = require('sinon')
should = require('should')

global.GeolocationService = require('api/services/GeolocationService')
Shipment = wolfpack('api/models/Shipment')

example_geolocation_data = {
   "results" : [
      {
         "formatted_address" : "Union Square, San Francisco, CA 94108, USA",
         "geometry" : {
            "location" : {
               "lat" : 37.7879938,
               "lng" : -122.4074374
            },
         }
      }
   ],
   "status" : "OK"
}

it_should_require = (attribute) ->
  it('should require ' + attribute, ->
    Shipment.attributes[attribute].required.should.be.true
  )

describe('Shipment', ->
  on_geolocation = null

  beforeEach(->
    on_geolocation = (address, onSuccess, onError) ->
      onSuccess(example_geolocation_data)

    sinon.stub(global.GeolocationService, 'fetch_coordinates_for_address', (address, onSuccess, onError) ->
      on_geolocation(address, onSuccess, onError)
    )
  )

  afterEach(->
    global.GeolocationService.fetch_coordinates_for_address.restore()
  )

  it_should_require('cost')
  it_should_require('destination_address')

  describe('#create', ->

    it('should geolocate the destination', (done) ->
      Shipment.create({ cost: 2.50, destination_address: 'Union Square' }).done((err, shipment) ->
        should.exist(shipment)
        shipment.destination_latitude.should.equal(example_geolocation_data.results[0].geometry.location.lat)
        shipment.destination_longitude.should.equal(example_geolocation_data.results[0].geometry.location.lng)
        done()
      )
    )

    it('still saves if it cant geolocate the destination', (done) ->
      on_geolocation = (address, onSuccess, onError) ->
        onError('Something went terribly, horribly wrong.')

      Shipment.create({ cost: 2.50, destination_address: 'Union Square' }).done((err, shipment) ->
        should.exist(shipment)
        should.not.exist(err)
        (shipment.destination_latitude == null).should.be.true
        (shipment.destination_longitude == null).should.be.true
        done()
      )
    )
  )
)