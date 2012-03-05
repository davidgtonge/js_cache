Store = require "../js/js_cache.js"

# Helper functions that turn Qunit tests into nodeunit tests
equals = []

test ?= (name, test_cb) ->
  exports[name] = (testObj) ->
    equals = []
    test_cb()
    for result in equals
      testObj.equal result[0], result[1]
    testObj.done()

equal ?= (real, expected) -> equals.push [real, expected]



test "Generic Cache Operations", ->

  a = new Store 10
  a.set "abc", 12345

  equal a.get("abc"), 12345
  equal a.size(), 1

  a.remove "abc"
  equal a.get("abc"), undefined
  equal a.size(), 0

  a.mset
    jkl:123
    def:456
    qwe:1234
    ghj:23
    cvb:322
    hjkjh:345
    sdfsd:273

  equal a.size(), 7

  a.set "jkl", 444

  equal a.size(), 7
  equal a.get("jkl"), 444

  a.mset
    cvbc:111
    ccx:222
    bnb:333
    lfd:444

  equal a.size(), 10
  equal a.get("def"), undefined
  equal a.get("jkl"), 444

  a.mremove ["ccx","bnb","lfd"]
  equal a.size(), 7

  [results, missing] = a.mget ["cvb","qwe", "bnb"]

  equal results.cvb, 322
  equal missing[0], "bnb"
  equal missing.length, 1

  gen_key = a.add 23423423
  equal gen_key, "jsc_0"
  gen_key = a.add 223423
  equal gen_key, "jsc_1"

  equal a.get("jsc_0"), 23423423




