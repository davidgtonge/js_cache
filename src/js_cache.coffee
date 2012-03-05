idCounter = 0

class Store

  constructor: (@_limit = 1000) ->
    @_data = {}
    @_keys = []

  get: (key) -> @_data[key]
  mget: (keys) ->
    results = {}
    missing = []
    for key in keys
      found = @get key
      if found then results[key] = found else missing.push key
    [results, missing]

  mset: (data, expires = false) ->
    for key, vars of data
      @set key, vars, expires
  set: (key, vars, expires = false) ->
    @_splice key if @_data[key]
    @_data[key] = vars
    @_keys.push key
    @_shift() if @_keys.length > @_limit
    if expires then setTimeout @remove, expires, key

  add: (vars) ->
    key = "jsc_" + idCounter++
    @set key, vars
    key

  mremove: (keys) -> @remove key for key in keys
  remove: (key) =>
    if @_data[key]
      delete @_data[key]
      @_splice key

  clear: ->
    @_data = {}
    @_keys = []


  size: -> @_keys.length
  _shift: -> delete @_data[@_keys.shift()]
  _splice: (key) -> @_keys.splice @_keys.indexOf(key), 1

module.exports = Store