# Sedefast

concatenative, Joy-like front-end to the [Sidef](https://github.com/trizen/sidef) programming language.

(for a polished implementation of a modern functional/concatenative programming system, see [Factor](https://github.com/factor/factor) -- it's much more clever.)

---

An investigation into how simple such an implementation can be, given Sidef's key relevant limitation:

Perl subprograms have no defined argument list, and Sidef has widely-used support for variadic arguments and function overloading, which are fundamentally incompatible with direct translation to concatenativity.

For the program `1 2 +`, it outputs `3`, which is pretty good for 15 minutes and 35 lines:
```
[1]
[1, 2]
[3]
```

Currently the solution is to brute-force the number of arguments, as right now we are only supporting number literals and their methods like `+` and `-`.

When reading a non-number token, the interpreter takes the top item off the stack and applies `.method("#{token}")` to it, for example resulting in a LazyMethod that will call `Number.+`.

This way causes a problem for functions that take no arguments, but that is not currently handled.

Because we can know neither the number of arguments to a Perl sub (without parsing the Perl code) nor the number of arguments to a Sidef function by *name alone* due to overloading and variance, we have to try every invocation with as many arguments as possible, until we find one that works.

This is actually overkill for Number methods, most of which take exactly 1 or 2 arguments and have no overloads, but it has solved a future problem.

As in modern concatenative languages, varargs and keyword arguments (NamedParam) will be supported by single Array and Hash inputs, respectively, with a concatenative syntax.

We have 3 main kinds of syntax when making Joy translate directly to Sidef:

1. Syntax for single objects that "just works", like `123`, and later, strings, regexes...

2. Things that exist in Joy but not in Sidef, like `square = dup * ;` (which is actually non-concatenative), and lists without a comma operator `[ 1 2 ]` -> `Array(1, 2)`.

3. Things that exist in Sidef but not Joy, like mutability, references, methods...

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
