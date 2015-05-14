###
Maintain a cache of queries to reduce re-querying.
###

async = require 'odo-async'
diff = require './diff'
optimise = require './optimise'
parallelqueries = require './parallelqueries'

module.exports = (exe, options) ->
  options = {} if !options?
  if !options.maxparallelqueries?
    options.maxparallelqueries = 5
  _cached = {}
  _e =
    ready: []
    result: []
    error: []
  pq = parallelqueries options.maxparallelqueries, (timings) ->
    e timings for e in _e.ready
  
  res = ->
  res.apply = (queries) ->
    for key, _ of queries
      _cached[key] = queries[key]
  res.run = (queries) ->
    queries = diff _cached, queries
    optimisedqueries = optimise exe, queries
    async.delay ->
      for query in optimisedqueries
        do (query) ->
          pq.add query.keys, (cb) ->
            query.query (errors, results) ->
              if errors?
                e errors for e in _e.error
              cb errors, (keys) ->
                update = {}
                for key in keys
                  console.log key
                  _cached[key] = queries[key]
                  update[key] = results[key]
                e update for e in _e.result
      pq.exec()
  res.on = (e, cb) ->
    _e[e] = [] if !_e[e]?
    _e[e].push cb
  res