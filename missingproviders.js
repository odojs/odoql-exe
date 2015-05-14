// Generated by CoffeeScript 1.9.1
var isquery, missingproviders;

isquery = require('./isquery');

missingproviders = function(exe, query) {
  var key, res, value;
  if (typeof query !== 'object') {
    return [];
  }
  if (isquery(query) && (exe.providers[query.__q] == null)) {
    return [query.__q];
  }
  res = [];
  for (key in query) {
    value = query[key];
    res = res.concat(missingproviders(exe, value));
  }
  return res;
};

module.exports = missingproviders;
