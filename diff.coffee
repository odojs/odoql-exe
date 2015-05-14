eq = require './eq'

# we've executed a, and now want to execute b
# can we skip queries?
module.exports = (a, b) ->
  result = {}
  for key, query of b
    continue if a[key]? and query.__q isnt 'nocache' and eq a[key], query
    result[key] = query
  result