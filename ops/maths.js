// Generated by CoffeeScript 1.9.2
var binarymath, fn, fn1, helpers, i, j, len, len1, op, res, uniarymath;

helpers = require('../helpers');

res = {
  binary: {
    add: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left + right;
      });
    },
    sub: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left - right;
      });
    },
    div: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left / right;
      });
    },
    mult: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left * right;
      });
    },
    mod: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left % right;
      });
    }
  },
  unary: {},
  params: {
    interpolate_linear: function(exe, params) {
      return helpers.params(exe, params, function(params, source) {
        var input, output, x1, x2, y1, y2;
        if (Object.keys(params).length === 0) {
          return null;
        }
        x1 = -Infinity;
        x2 = +Infinity;
        for (input in params) {
          output = params[input];
          input = +input;
          if (input === source) {
            return output;
          }
          if (input < source && input > x1) {
            x1 = input;
          }
          if (input > source && input < x2) {
            x2 = input;
          }
        }
        if (x1 === -Infinity || x2 === +Infinity) {
          return null;
        }
        y1 = params[x1];
        y2 = params[x2];
        return y1 + (y2 - y1) * ((source - x1) / (x2 - x1));
      });
    },
    toFixed: function(exe, params) {
      return helpers.params(exe, params, function(params, source) {
        return source.toFixed(params);
      });
    }
  }
};

binarymath = ['pow', 'atan2'];

fn = function(op) {
  var operation;
  operation = Math[op];
  return res.binary[op] = function(exe, params) {
    return helpers.binary(exe, params, function(left, right) {
      return operation(left, right);
    });
  };
};
for (i = 0, len = binarymath.length; i < len; i++) {
  op = binarymath[i];
  fn(op);
}

uniarymath = ['abs', 'acos', 'asin', 'atan', 'ceil', 'cos', 'exp', 'floor', 'log', 'round', 'sin', 'sqrt', 'tan'];

fn1 = function(op) {
  var operation;
  operation = Math[op];
  return res.unary[op] = function(exe, params) {
    return helpers.unary(exe, params, function(source) {
      return operation(source);
    });
  };
};
for (j = 0, len1 = uniarymath.length; j < len1; j++) {
  op = uniarymath[j];
  fn1(op);
}

module.exports = res;
