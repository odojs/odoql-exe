module.exports = (callback) ->
  params: __dynamic: (exe, params) ->
    (cb) -> callback params.__p, params.__s, cb