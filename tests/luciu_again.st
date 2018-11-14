[
Luciu("luciu_again"): {
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
  lives({ say "this only prints" })
}
]