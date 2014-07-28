###
  ShipmentController

  @module      :: Controller
  @description	:: A set of functions called `actions`.

                  Actions contain code telling Sails how to respond to a certain type of request.
                  (i.e. do stuff, then send some JSON, show an HTML page, or redirect to another URL)

                  You can configure the blueprint URLs which trigger these actions (`config/controllers.js`)
                  and/or override them with custom routes (`config/routes.js`)

                  NOTE: The code you write here supports both HTTP and Socket.io automatically.

  @docs        :: http://sailsjs.org/#!documentation/controllers
###

ShipmentController = {
  get: (request, response) ->
    Shipment.find(request.param('id')).exec((error, shipment) ->
      return response.send(error, 500) if error
      return response.send("No shipment with that id exists.", 404) if !shipment

      response.json(shipment)
    )

  create: (request, response) ->
    Shipment.create(request.body).done((error, shipment) ->
      return response.send(error, 500) if error

      response.json(shipment)
    )


  update: (request, response) ->
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