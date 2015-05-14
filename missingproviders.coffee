isquery = require './isquery'

missingproviders = (exe, query) ->
  return [] unless typeof(query) is 'object'
  if isquery(query) and !exe.providers[query.__q]?
    return [query.__q]
  res = []
  for key, value of query
    res = res.concat missingproviders exe, value
  res

module.exports = missingproviders