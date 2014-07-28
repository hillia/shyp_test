https = require('https')
querystring = require("querystring");

exports.fetch_coordinates_for_address = (address, onSuccess, onError) ->

    options = {
        host: 'maps.googleapis.com',
        path: '/maps/api/geocode/json?' + querystring.stringify({ address: address })
    }

    _onError = (error) ->
        console.log("FAILED TO GET GEOLOCATION: ", error)
        onError(error) if onError

    _onSuccess = (response) ->
        body = ""
        response.on('data', (chunk) ->
            body += chunk
        )
        response.on('end', () ->
            geo_data = JSON.parse(body)
            onSuccess(geo_data)
        )

    https.get(options, _onSuccess).on('error', _onError)