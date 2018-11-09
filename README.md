# Sedefast

concatenative, Joy-like front-end to the [Sidef](https://github.com/trizen/sidef) programming language.

---

more properly, an investigation into how simple such an implementation can be, given Sidef's key relevant limitation:

Perl subprograms have no defined argument list, and Sidef has widely-used support for variadic arguments, which are fundamentally incompatible with direct translation to concatenativity.

For the program `1 2 +`, it outputs `3`, which is pretty good for 15 minutes and 35 lines:
```
[1]
[1, 2]
[3]
```

...

Names of modules:

* first, "Sidef" means "nacre" in Romanian

* so "Sedefast" means "nacreous" in Serbian
  * in `.sc` (Sidef-concatenative) or `.se` files
  * not "faster than S[i]def", but maybe faster than C. ;)

* "Luciu", "luster" in Romanian
  * it tests the glossiness of your Sidef code, in `.st` files
  * `luciu::Meter` is a glossometer for *really* testing shinyness

* "Opis", "description" in Serbian
  * it generates documentation from Sidef source and `.sd` supplement


---

This ENTIRE repository is dual-licensed, Artistic 2.0 and GPLv3; use the one you want.
