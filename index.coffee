isquery = require './isquery'
ops = require './ops'

literal = (exe, value) ->
  if isquery value
    (cb) -> cb null, value.__s
  else
    (cb) -> cb null, value

module.exports = (options) ->
  providers = literal: literal
  res =
    providers: providers
    clear: ->
      providers = literal: literal
    use: (def) ->
      if def instanceof Array
        res.use def for d in def
        return res
      for _, optype of def
        for name, fn of optype
          providers[name] = fn
      res
    build: (q) ->
      return res.providers.literal res, q unless isquery q
      if !res.providers[q.__q]?
        throw new Error "#{q.__q} not found"
      return res.providers[q.__q] res, q
  res.use def for def in ops
  res