expect = require('chai').expect
ql = require 'odoql'
ql = ql()

exe = require '../'
exe = exe()

source = -> [
  { x: 2, y: 5 }
]

describe 'assign', ->
  it 'should create a new property', (done) ->
    query = ql source()
      .assign
        value2: ql.ref 'y'
      .query()
    exe.build(query) (err, result) ->
      expect(err).to.be.null
      expect(result).to.have.length 1
      expect(result[0]).to.have.all.keys ['x', 'y', 'value2']
      done()

  it 'should replace an existing property', (done) ->
    query = ql source()
      .assign
        y: ql.ref 'y'
      .query()
    exe.build(query) (err, result) ->
      expect(err).to.be.null
      expect(result).to.have.length 1
      expect(result[0]).to.have.all.keys ['x', 'y']
      done()

  it 'should assign multiple properties at once', (done) ->
    query = ql source()
      .assign
        y2: ql.ref 'y'
        y3: ql.ref 'y'
        y4: ql.ref 'y'
      .query()
    exe.build(query) (err, result) ->
      expect(err).to.be.null
      expect(result).to.have.length 1
      expect(result[0]).to.have.all.keys ['x', 'y', 'y2', 'y3', 'y4']
      done()

  it 'should apply to a deep calculation', (done) ->
    query = ql source()
      .assign
        y2: (
          ql 'y'
            .ref()
            .add 1
            .mult ql.ref 'x'
            .div 3
            .fill
              param1: 5
              param2: 2
            .query())
      .query()
    exe.build(query) (err, result) ->
      expect(err).to.be.null
      expect(result).to.have.length 1
      expect(result[0]).to.have.all.keys ['x', 'y', 'y2']
      expect(result[0].y2).to.be.equal 4
      done()