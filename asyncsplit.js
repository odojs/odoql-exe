// Generated by CoffeeScript 1.9.2

/*
Split queries into queries to execute together and queries that can complete independently.
 */
var hasoption;

hasoption = require('./hasoption');

module.exports = function(exe, queries) {
  var async, key, query, sync;
  sync = {};
  async = {};
  for (key in queries) {
    query = queries[key];
    if (hasoption(query, 'async')) {
      async[key] = query;
    } else {
      sync[key] = query;
    }
  }
  return {
    sync: sync,
    async: async
  };
};
