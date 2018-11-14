# Luciu

mini test framework for Sidef

"Luciu" means "glossiness" in Romanian; it should probably be "lucios" but that doesn't sound as good

## Expressions, cases, and groups

A Luciu *expression* isn't a Sidef expression, it's a call to an assertion-like function. An expression looks like `is()`, `lives({})`, etc (though you can bind the expression methods to any names).

A non-empty Luciu *case* has the form `Luciu(String case_name): { expressions... }`; the alias `Case` can be substituted. An empty case has no expressions and no `skip()`, or `die`s before executing any Luciu expressions.

A non-empty Luciu *group* is the form `[ cases... ]`. A test file should contain exactly one such group; only the last group in a file will be used (by nature of `eval`).

A literal group (an Array of Cases) is anonymous inside a file; during execution a group gets the name of the relative path of its enclosing file.

Therefore, groups are the Luciu representation of a test file on disk; disk test files are the "tangible" data representation of the Luciu group. They are more or less interchangeable, except that "groups" do not simply exist in the filesystem, only in files.

## Model
An *object* is a directory, group, or case form, and importantly *not* an expression.

Each object can have a State:
* completed, crashed, empty

and a Result:
* failed, passed, skipped

An object has one state and one result. The combination "Crashed+Passed" is meaningless but might be used in the future.

Expressions are too fine-grained to be objects, and have neither a Result nor a State: they have a Reason member (`reason`) containing a `result` which is either `Expression::PASS` or `Expression::FAIL`.

Expressions are essentially atomic despite the number of operations in each `is` call; an expression either ran or did not run.

| State/Result 	|              Completed              	|            Crashed           	|             Empty             	|
|:------------:	|:-----------------------------------:	|:----------------------------:	|:-----------------------------:	|
|    Passed    	| contains no failing case/expression 	|                              	| file contains empty `[]` form 	|
|    Failed    	|  contains a failing case/expression 	| an uncaught error was thrown 	|  case contains no expressions 	|
|    Skipped   	|        successfully skipped*        	|        ignored crash*        	|   file contains no `[]` form  	|

\* due to testing configuration

* Completed: when a case executes to completion; a group containing only completed cases is also *completed*
  * Failed: expression in a case doesn't run as specified; the case continues executing but is marked *failed*

  * Passed: all expressions in a given case, file, or directory ran as specified

  * Skipped: case contains `skip()` expression, or a file was skipped due to configuration

* Crashed: a case directly or indirectly calls `die`, `warn` (with `-W`), or a failing `assert*()`, stopping execution of the case expressions after the crash, and causing its group to also be marked *crashed*

  * F: default Result for a Crashed case or file; "Crashed+Failed" propagates up the stack like "Completed+Failed"

  * S: configuration specifies this file should have its crashes ignored

* Empty
  * F: case with no expressions and no `skip()`, like `Luciu("empty"): {}`, because entirely forgetting to call the test framework is a bug

  * P: an empty group `[ ]`

  * S: a file containing no `[ ]` form at all, which has no return value, and thus no meaning

A file without a `[ ]` form is not considered an error (unless specified by configuration), but a diagnostic is issued.

A group is Completed+Skipped when all of its cases call `skip()`, or when the configuration marks it to be skipped.

## Configuration

in order to implement directories and per-directory `.luciu` config properly, we need to:

1. eat a list of directories from the command line and goto #3
  * otherwise find `./tests` (case insensitive) and goto #2

2. if it contains `.luciu`, eat that configuration and store it for the current directory "scope" (i.e contained files)
  * otherwise, stop

3. if any subdirectories contain a `.luciu`, goto #2

4. otherwise, test any files and directories specified by the current `./.luciu`, including directories without `.luciu`

5. say the collected test data

6. stop

traversed directories have to be collected in a nested Hash structure (`Hash("name" => [ ... ], "config" => Config)`)

also todo: report file failures immediately correctly

## Example output

```
How glossy is your Sidef?

Opening 'tests/'...
 Testing cases in 'tests/really_empty.st'...
 Tested 'tests/really_empty.st'
 Testing cases in 'tests/luciu.st'...
   TEST Case 'luciu1'...
	PASS	equality	[true]
	PASS	equality	["a", "a"]
	PASS	equality	[[1, 2, 3], [1, 2, 3]]
	PASS	equality	[]
	PASS	equality	[1, 1, 1]
	PASS	inequality	["1", "a"]
	PASS	inequality	[false]
	PASS	inequality	[[1, 2, 3], [1, 2]]
	PASS	inequality	[1, 2, 3, 4]
	PASS	inequality	[1, 2, 3, 4]
	PASS	dies		[native code]
	PASS	dies		[native code]
	PASS	dies		[native code]
	PASS	lives		[native code]
   PASS Case 'luciu1'

   TEST Case 'luciu2'...
	PASS	equality	["a", "a"]
	PASS	equality	[[1, 2, 3], [1, 2, 3]]
	PASS	equality	[true]
	PASS	equality	[]
	PASS	equality	[1, 1, 1]
	PASS	inequality	["1", "a"]
	PASS	inequality	[false]
	PASS	inequality	[[1, 2, 3], [1, 2]]
	PASS	inequality	[1, 2, 3, 4]
	PASS	dies		[native code]
	PASS	dies		[native code]
	PASS	dies		[native code]
	PASS	lives		[native code]
   PASS Case 'luciu2'

 Tested 'tests/luciu.st'
 Testing cases in 'tests/again.st'...
   TEST Case 'skip_empty'...
   SKIP Case 'skip_empty'

   TEST Case 'empty_no_skip'...
  EMPTY devoid of expressions (without calling skip())
   FAIL Case 'empty_no_skip'
      1 failed -> case has no expressions and doesn't call skip()

   TEST Case 'another_case'...
	PASS	says		'this shou...' ~~ '/shouldn'...'
   PASS Case 'another_case'

 Tested 'tests/again.st'
 Testing cases in 'tests/luciu_again.st'...
   TEST Case 'luciu_again'...
	PASS	equality	["a", "a"]
	PASS	equality	[[1, 2, 3], [1, 2, 3]]
	PASS	equality	[true]
	PASS	equality	[]
	PASS	equality	[1, 1, 1]
	PASS	inequality	["1", "a"]
	PASS	inequality	[false]
	PASS	inequality	[[1, 2, 3], [1, 2]]
	PASS	inequality	[1, 2, 3, 4]
	PASS	dies		[native code]
	PASS	dies		[native code]
	PASS	dies		[native code]
	PASS	lives		[native code]
this only prints
	PASS	lives		[native code]
   PASS Case 'luciu_again'

 Tested 'tests/luciu_again.st'
 Testing cases in 'tests/empty.st'...
 Tested 'tests/empty.st'
Finished 'tests/'.

Planned  5 Groups  6 Cases 42 Exprs

         Completed Crashed Empty   
Passing  2 4 42            1 0     
Failing  1 0 0     0 0     0 1     
Skipping 0 1       0 0     1 0     
         G C E     G C     G C     
```

## Output format
