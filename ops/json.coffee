module.exports =
  unary:
    json: (exe, params) ->
      getsource = exe.build params.__s
      (cb) ->
        getsource (err, source) ->
          return cb err if err?
          try
            cb null, JSON.parse source
          catch e
            cb e