###
Given an execution environment (exe) create a list of
queries that can execute locally, and another list of
queries to execute somewhere else.
###

canexecute = require './canexecute'
missingproviders = require './missingproviders'

module.exports = (exe, queries) ->
  local = {}
  remote = {}
  missing = {}
  for key, query of queries
    if canexecute exe, query
      local[key] = query
    else
      remote[key] = query
      missing[key] = missingproviders exe, query
  local: local
  remote: remote
  missing: missing