isquery = require './isquery'

canexecute = (exe, query) ->
  return yes unless typeof(query) is 'object'
  return no if isquery(query) and !exe.providers[query.__q]?
  for key, value of query
    return no unless canexecute exe, value
  yes

module.exports = canexecute