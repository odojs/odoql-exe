###
Given an object of named queries, return a function
that will execute them all and return errors and the
result.

e.g.
{
  user: ql.queryforuser()
  org: ql.queryforuser()
}
###

async = require 'odo-async'

module.exports = (exe, queries) ->
  if queries instanceof Array
    return (cb) ->
      errors = {}
      results = {}
      tasks = []
      for query in queries
        do (query) ->
          tasks.push (cb) ->
            query.query (err, res) ->
              if err?
                for key in query.keys
                  errors[key] = err[key]
                cb()
              for key in query.keys
                results[key] = res[key]
              cb()
      async.parallel tasks, ->
        if Object.keys(errors).length is 0
          cb null, results
        else
          cb errors, results
  
  built = {}
  for key, query of queries
    built[key] = exe.build query
  (cb) ->
    errors = {}
    results = {}
    tasks = []
    for key, run of built
      do (key, run) ->
        tasks.push (cb) ->
          run (err, res) ->
            if err?
              errors[key] = err
            else
              results[key] = res
            cb()
    async.parallel tasks, ->
      if Object.keys(errors).length is 0
        cb null, results
      else
        cb errors, results