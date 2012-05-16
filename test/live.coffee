SMS = require INDEX

describe 'SMSified Session', ->

    it 'should return a 201 status', (done) ->
        @expectCount(2)

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
