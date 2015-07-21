extend = require 'extend'
visit = require '../visit'

module.exports =
  unary:
    param: (exe, params) ->
      throw new Error 'Parameters should not be executed'
  params:
    fill: (exe, params) ->
      getparams = exe.build params.__p
      (callback) ->
        getparams (err, properties) ->
          return callback err if err?
          fillparams = (node, cb) ->
            return cb() if !node.__q? or node.__q isnt 'param'
            getref = exe.build node.__s
            getref (err, res) ->
              throw new Error err if err?
              return cb properties[res] if properties[res]?
              cb()
          # copy def
          visit params.__s, fillparams, (filled) ->
            getref = exe.build filled
            getref (err, result) ->
              return callback err if err?
              callback null, result