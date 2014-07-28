###
  ShipmentController

  @module      :: Controller
  @description	:: REST API for Shipment models
###

ShipmentController = {
  get: (request, response) ->
    Shipment.find(request.param('id')).exec((error, shipment) ->
      return response.send(error, 500) if error
      return response.send("No shipment with that id exists.", 404) if !shipment

      response.json(shipment)
    )

  create: (request, response) ->
    // TODO: Shouldn't be accepting every param. Investigate attribute whitelisting for Sails
    Shipment.create(request.body).done((error, shipment) ->
      return response.send(error, 500) if error

      response.json(shipment)
    )


  update: (request, response) ->
    // TODO: Shouldn't be accepting every param. Investigate attribute whitelisting for Sails
    Shipment.update({ id: request.param('id') }, request.body, (error, shipments) ->
      return response.send(error, 500) if error
      return response.send("No shipment with that id exists.", 404) if shipments.length == 0

      response.json(shipments[0])
    )


  destroy: (request, response) ->
    Shipment.destroy({ id: request.param('id') }).done( (error) ->
      return response.send(error, 500) if error
      response.send('OK', 200)
    )
}

module.exports = ShipmentController