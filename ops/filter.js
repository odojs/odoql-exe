// Generated by CoffeeScript 1.9.1
var async, extend, visit;

extend = require('odoql-utils/extend');

async = require('odoql-utils/async');

visit = require('odoql-utils/visit');

module.exports = {
  params: {
    filter: function(exe, params) {
      var getsource;
      getsource = exe.build(params.__s);
      return function(callback) {
        return getsource(function(err, source) {
          var data, fn, i, index, len, results, tasks;
          if (err != null) {
            return callback(err);
          }
          if (!(source instanceof Array)) {
            throw new Error('Not an array');
          }
          results = [];
          tasks = [];
          fn = function(data, index) {
            return tasks.push(function(cb) {
              var def, fillrefs;
              fillrefs = function(node, cb) {
                var getref;
                if ((node.__q == null) || node.__q !== 'ref') {
                  return cb();
                }
                getref = exe.build(node.__s);
                return getref(function(err, res) {
                  var ref;
                  if (err != null) {
                    throw new Error(err);
                  }
                  return cb((ref = data[res]) != null ? ref : '');
                });
              };
              def = extend(true, {}, params.__p);
              return visit(def, fillrefs, function(filled) {
                var getref;
                if (err != null) {
                  return callback(err);
                }
                getref = exe.build(filled);
                return getref(function(err, value) {
                  if (err != null) {
                    return callback(err);
                  }
                  results[index] = value;
                  return cb();
                });
              });
            });
          };
          for (index = i = 0, len = source.length; i < len; index = ++i) {
            data = source[index];
            fn(data, index);
          }
          return async.series(tasks, function() {
            var j, len1, result, should;
            result = [];
            for (index = j = 0, len1 = results.length; j < len1; index = ++j) {
              should = results[index];
              if (should) {
                result.push(source[index]);
              }
            }
            return callback(null, result);
          });
        });
      };
    }
  }
};
