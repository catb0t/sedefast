[

Luciu("luciu").go{
  |is, isnt, dies, lives|

  is(("a" =~ /(a)/)[0], "a")
  is([1, 2, 3], [1, 2, 3])
  is(true)
  is()
  is(1, 1, 1) # fails
  #die "dies"

  isnt(("a" =~ /a/)[0], "a")
  isnt(false)      # like assert_ne
  isnt([1, 2, 3], [1, 2])
  isnt(1, 2, 3, 4) # different
  isnt(1, 2, 3, 4) # all different

  dies({ die "this should die" }, regexes: [/error/, /should/])
  dies({ die "dies differently" }, regexes: [/error/, /differ/])
  dies({ die _ }, "died with argument", regexes: [/error/, /argu/])
  lives({ warn "this shouldn't die" })
}

Luciu("luciu2").go{
  |is, isnt, dies, lives|

  is(("a" =~ /(a)/)[0], "a")
  is([1, 2, 3], [1, 2, 3])
  is(true)
  is()

  is(1, 1, 1)

  isnt(("a" =~ /a/)[0], "a")
  isnt(false)      # like assert_ne
  isnt([1, 2, 3], [1, 2])
  isnt(1, 2, 3, 4) # all different

  dies({ die "this should die" }, regexes: [/error/, /should/])
  dies({ die "dies differently" }, regexes: [/error/, /differ/])
  dies({ die _ }, "died with argument", regexes: [/error/, /argu/])
  lives({ warn "this shouldn't die" })
}

]
