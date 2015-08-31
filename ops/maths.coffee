helpers = require '../helpers'

res =
  binary:
    add: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left + right
    sub: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left - right
    div: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left / right
    mult: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left * right
    mod: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left % right
  unary: {}
  params:
    interpolate_linear: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        return null if Object.keys(params).length is 0
        x1 = -Infinity
        x2 = +Infinity
        for input, output of params
          input = +input
          return output if input == source
          x1 = input if input < source and input > x1
          x2 = input if input > source and input < x2
        return null if x1 is -Infinity or x2 is +Infinity
        y1 = params[x1]
        y2 = params[x2]
        y1 + (y2 - y1) * ((source - x1) / (x2 - x1))

binarymath = [
  'pow'
  'atan2'
]
for op in binarymath
  do (op) ->
    operation = Math[op]
    res.binary[op] = (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        operation left, right

uniarymath = [
  'abs'
  'acos'
  'asin'
  'atan'
  'ceil'
  'cos'
  'exp'
  'floor'
  'log'
  'round'
  'sin'
  'sqrt'
  'tan'
]
for op in uniarymath
  do (op) ->
    operation = Math[op]
    res.unary[op] = (exe, params) ->
      helpers.unary exe, params, (source) ->
        operation source

module.exports = res