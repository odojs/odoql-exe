eq = require './eq'
hasoption = require './hasoption'

# we've executed a, and now want to execute b
# can we skip queries?
module.exports = (a, b) ->
  result = {}
  for key, query of b
    continue if a[key]? and not hasoption(query, 'nocache') and eq a[key], query
    result[key] = query
  result