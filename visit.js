// Generated by CoffeeScript 1.9.1
var async, visit;

async = require('odo-async');

visit = function(node, nodecb, fincb) {
  if (typeof node !== 'object') {
    return fincb(node);
  }
  return nodecb(node, function(replacement) {
    var fn, key, tasks, value;
    if (replacement != null) {
      return fincb(replacement);
    }
    tasks = [];
    fn = function(key, value) {
      return tasks.push(function(cb) {
        return visit(value, nodecb, function(replacement) {
          node[key] = replacement;
          return cb();
        });
      });
    };
    for (key in node) {
      value = node[key];
      fn(key, value);
    }
    return async.series(tasks, function() {
      return fincb(node);
    });
  });
};

module.exports = visit;
