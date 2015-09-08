expect = require('chai').expect
ql = require 'odoql'
ql = ql()

exe = require '../'
exe = exe()

describe 'fill', ->
  it 'should fill in a parameter for concat', (done) ->
    query = ql 'test'
      .concat ql.param 'param1'
      .fill param1: 'name'
      .query()
    exe.build(query) (err, result) ->
      expect(err).to.be.null
      expect(result).to.equal 'testname'
      done()

  it 'should apply to a deep calculation', (done) ->
    query = ql 'param1'
      .param()
      .add 1
      .mult ql.param 'param2'
      .div 3
      .fill
        param1: 5
        param2: 2
      .query()
    exe.build(query) (err, result) ->
      expect(err).to.be.null
      expect(result).to.equal 4
      done()