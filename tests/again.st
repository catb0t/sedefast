[
Luciu("skip_empty"): {
  |a, b, c, d, skip|
  skip()
},


Luciu("empty_no_skip"): {
},

Luciu("another_case"): {
 |is, isnt, dies, lives, skip, says|
 says({ say "this shouldn't die" }, /shouldn't/)
}
]
