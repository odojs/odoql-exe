split = require './split'

module.exports = (exe, queries) ->
  queries = split exe, queries
  result = []
  for key, query of queries.local
    do (key, query) ->
      query = exe.build query
      result.push
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
  return result if keys.length is 0
  result.push
    keys: keys
    query:
      exe.providers.__dynamic exe,
        __q: '__dynamic'
        __p: keys
        __s: queries.remote
  return result