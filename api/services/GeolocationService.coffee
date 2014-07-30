https = require('https')
querystring = require("querystring")

exports.fetch_coordinates_for_address = (address, onSuccess, onError) ->

    options = {
        host: 'maps.googleapis.com',
        path: '/maps/api/geocode/json?' + querystring.stringify({ address: address })
    }

    _onError = (error) ->
        console.log("Failed to retrieve geolocation data: ", error);
        onError(error) if onError

    _onSuccess = (response) ->
        body = ""
        response.on('data', (chunk) ->
            body += chunk
        )
        response.on('end', ->
            try
                geo_data = JSON.parse(body)
                onSuccess(geo_data)
            catch error
                console.log("Geolocation data malformed: ", body);
                onError(error)
        )

    https.get(options, _onSuccess).on('error', _onError)