HTTPS = require 'https'

SMS = require INDEX

gHttpsRequest = HTTPS.request


describe 'SMSified Session', ->

    afterEach (done) ->
        HTTPS.request = gHttpsRequest
        return done()

    it 'should', (done) ->
        @expectCount(3)

        # Setup Mocking
        HTTPS.request = (opts, callback) ->
            dataHandler = null
            endHandler = null

            req =
                on: ->

                write: (data) ->
                    expect(data).toBe('address=5555555555&message=automated%20hello%20test')
                    return

                end: ->
                    process.nextTick ->
                        callback(res)
                        return end()
                    return

            res =
                statusCode: 201
                setEncoding: ->

                on: (name, handler) ->
                    if name is 'data' then dataHandler = handler
                    if name is 'end' then endHandler = handler
                    return

            end = ->
                dataHandler('{"resourceURL":"http://someurl"}')
                process.nextTick ->
                    return endHandler()
                return

            return req

        session = new SMS.Session({
            username: USERNAME
            password: PASSWORD
            address: ADDRESS
        })

        test = (res) ->
            expect(res.code).toBe(201)
            expect(res.data.resourceURL).toBeA('string')
            return done()

        session.send(TARGET, 'automated hello test').then(test).fail (err) ->
            console.error('Testing failure:')
            console.error(err.toString())
            return done(err)
        return

    return
