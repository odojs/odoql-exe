split = require './split'
asyncsplit = require './asyncsplit'

module.exports = (exe, queries) ->
  result = []
  build = (isAsync, queries) ->
    for key, query of queries.local
      do (key, query) ->
        query = exe.build query
        result.push
          isAsync: isAsync
          keys: [key]
          query: (cb) ->
            query (err, res) ->
              if err?
                returnresult = {}
                returnresult[key] = err
                return cb returnresult
              returnresult = {}
              returnresult[key] = res
              cb null, returnresult
    keys = Object.keys queries.remote
    if keys.length isnt 0
      result.push
        isAsync: isAsync
        keys: keys
        query:
          exe.providers.__dynamic exe,
            __q: '__dynamic'
            __p: keys
            __s: queries.remote

  queries = asyncsplit exe, queries
  console.log 'optimise1'
  console.log queries
  queries =
    sync: split exe, queries.sync
    async: split exe, queries.async
  console.log 'optimise2'
  console.log queries
  build no, queries.sync
  build yes, queries.async
  result