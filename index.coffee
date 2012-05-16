###
copyright: (c) 2012 by Fireworks Project Inc. (http://www.fireworksproject.com).

Unless otherwise indicated, all source code is licenced under the MIT license.
See MIT-LICENSE in the root directory for details.
###

HTTPS = require 'https'
QS = require 'querystring'

Q = require 'q'

DOMAIN = 'api.smsified.com'
API = 'v1'


class Session

    # aSpec.username
    # aSpec.password
    # aSpec.address
    constructor: (aSpec) ->
        @username = aSpec.username
        @password = aSpec.password
        @address = aSpec.address

    # aOpts.method
    # aOpts.path
    # [aOpts.data]
    makeRequest: (aOpts, aData) ->
        deferred = Q.defer()
        method = aOpts.method

        data = if method is 'POST' and aData
            QS.stringify(aData)
        else null

        authstring = new Buffer("#{@username}:#{@password}")
            .toString('base64')

        headers =
            'Authorization': "Basic #{authstring}"

        if data
            headers['Content-Type'] = 'application/x-www-form-urlencoded'
            headers['Content-Length'] = Buffer.byteLength(data).toString()

        opts =
            method: method
            hostname: DOMAIN
            path: aOpts.path
            headers: headers

        req = HTTPS.request opts, (res) ->
            body = ''

            res.setEncoding('utf8')
            res.on 'data', (chunk) ->
                body += chunk
                return

            res.on 'error', (err) ->
                return deferred.reject(err)

            res.on 'end', ->
                res.body = JSON.parse(body)
                return deferred.resolve(res)

            return

        req.on 'error', (err) ->
            return deferred.reject(err)

        if data
            req.write(data)

        req.end()
        return deferred.promise

    send: (aAddr, aMsg) ->
        opts =
            method: 'POST'
            path: "#{Session.createBasePath()}outbound/#{@address}/requests"
        data = {address: aAddr, message: aMsg}

        handle = (res) ->
            data = res.body or {}
            rv = {code: res.statusCode}

            if not data.resourceReference
                rv.data = data
                return rv

            rv.data = data.resourceReference
            return rv

        return @makeRequest(opts, data).then(handle)

    @createBasePath = ->
        return "/#{API}/smsmessaging/"


exports.Session = Session
