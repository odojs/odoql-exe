###
Split queries into queries to execute together and queries that can complete independently.
###

hasoption = require './hasoption'

module.exports = (exe, queries) ->
  sync = {}
  async = {}
  for key, query of queries
    if hasoption query, 'async'
      async[key] = query
    else
      sync[key] = query
  sync: sync
  async: async