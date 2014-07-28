###
  Shipment

  @module      :: Model
  @description :: Represents the status, location and size of a package being shipped.
###
Shipment = {

  attributes: {
    status: {
      type: 'INTEGER',
      required: true,
      defaultsTo: 0
    }

    cost: {
      type: 'FLOAT',
      required: true
    },

    location_name: "STRING",
    location_latitude: 'FLOAT',
    location_longitude: 'FLOAT',

    destination_address: {
      type: 'STRING',
      required: true
    },
    destination_latitude: 'FLOAT',
    destination_longitude: 'FLOAT',

    package_width: "FLOAT"
    package_height: "FLOAT",
    package_depth: "FLOAT"
  },

  STATUSES: {
    0: "Created",
    1: "En route",
    2: "Delivered"
  },

  beforeValidation: (values, next) ->
    return next() if !values.destination_address

    onSuccess = (geo_data) ->
      values.destination_latitude = geo_data.results[0].geometry.location.lat
      values.destination_longitude = geo_data.results[0].geometry.location.lng
      next()

    onError = (error) ->
      values.destination_latitude = null
      values.destination_longitude = null
      next()

    GeolocationService.fetch_coordinates_for_address(values.destination_address, onSuccess, onError);

}

module.exports = Shipment
