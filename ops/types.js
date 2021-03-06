// Generated by CoffeeScript 1.9.1
var helpers;

helpers = require('../helpers');

module.exports = {
  unary: {
    asInt: function(exe, params) {
      return helpers.unary(exe, params, function(source) {
        return parseInt(source);
      });
    },
    asFloat: function(exe, params) {
      return helpers.unary(exe, params, function(source) {
        return parseFloat(source);
      });
    }
  }
};
