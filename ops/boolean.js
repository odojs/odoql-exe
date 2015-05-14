// Generated by CoffeeScript 1.9.1
var helpers;

helpers = require('../helpers');

module.exports = {
  binary: {
    or: function(exe, params) {
      var getleft, getright;
      getleft = exe.build(params.__l);
      getright = exe.build(params.__r);
      return function(cb) {
        return getleft(function(err, left) {
          if (err != null) {
            return cb(err);
          }
          if (left === true) {
            return cb(null, true);
          }
          return getright(function(err, right) {
            if (err != null) {
              return cb(err);
            }
            return cb(null, right);
          });
        });
      };
    },
    and: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left && right;
      });
    },
    gt: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left > right;
      });
    },
    gte: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left >= right;
      });
    },
    lt: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left < right;
      });
    },
    lte: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left <= right;
      });
    },
    eq: function(exe, params) {
      return helpers.binary(exe, params, function(left, right) {
        return left === right;
      });
    }
  },
  unary: {
    not: function(exe, params) {
      return helpers.unary(exe, params, function(source) {
        return !source;
      });
    }
  }
};
