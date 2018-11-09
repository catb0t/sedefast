# include luciu

[
  #`(luciu::)Test("strings").go({
    |is, isnt, dies|
    is(("a" =~ /(a)/)[0], "a")

    isnt(false) # should pass

    dies({ die "this should die" })
  })

]
