// Generated by CoffeeScript 1.9.1
module.exports = function(callback) {
  return {
    params: {
      __dynamic: function(exe, params) {
        return function(cb) {
          return callback(params.__p, params.__s, cb);
        };
      }
    }
  };
};
