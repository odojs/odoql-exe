###
Maintain a cache of queries to reduce re-querying.
###

async = require 'odo-async'
diff = require './diff'
optimise = require './optimise'
parallelqueries = require './parallelqueries'

module.exports = (exe, options) ->
  log = ->
  if options?.hub?
    log = (message) -> options.hub.emit '[odoql-exe] {message}', message: message

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
    if Object.keys(_cached).length > 0
      log "#{Object.keys(_cached).join ', '} in the cache"
    if Object.keys(queries).length > 0
      log "#{Object.keys(queries).join ', '} new or changed"
    optimisedqueries = optimise exe, queries
    async.delay ->
      for query in optimisedqueries
        do (query) ->
          pq.add query.keys, (cb) ->
            query.query (errors, results) ->
              if errors?
                log "#{Object.keys(errors).join ', '} errored"
                for key, error of errors
                  log "#{key}: #{error}"
                e errors for e in _e.error
              cb errors, (keys) ->
                log "#{keys.join ', '} complete, caching"
                update = {}
                for key in keys
                  _cached[key] = queries[key]
                  update[key] = results[key]
                e update for e in _e.result
      pq.exec()
  res.on = (e, cb) ->
    _e[e] = [] if !_e[e]?
    _e[e].push cb
  res