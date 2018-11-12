# Luciu

mini test framework for Sidef

"Luciu" means "glossiness" in Romanian; it should probably be "lucios" but that doesn't sound as good.

## Cases, files and expressions

A Luciu *expression* isn't a Sidef expression, it's a call to an assertion-like function. An expression looks like `is()`, `lives({})`, etc (though you can bind the expression methods to any names you like).

A non-empty Luciu *case* has the form `Luciu(String case_name).go{ expressions... }`. A case with no expressions, or no runnable expressions (for example because the block `die`d before any expression) is considered empty.

A non-empty Luciu *group* is the form `[ cases... ]`; a test file should contain exactly one group (but lists of anonymous groups may be used with the API).

A group is anonymous unless it is inside a file, in which case it has the file's name. The idea of a group is mostly interchangeable with a disk-file when using the API with disk-files.

## Model
An *object* is a directory, file/group, or case form.

Each object can have a State:
* completed, crashed, empty

and a Result:
* failed, passed, skipped

An object has one state and one result. The combination "Crashed+Passed" is meaningless but might be used in the future.

Expressions are not objects, and have neither a Result nor a State: they have a Reason member (`reason`) containing a `result` which is either `Expression::PASS` or `Expression::FAIL`.

| State/Result 	|              Completed              	|            Crashed           	|             Empty             	|
|:------------:	|:-----------------------------------:	|:----------------------------:	|:-----------------------------:	|
|    Failed    	|  contains a failing case/expression 	| an uncaught error was thrown 	|  case contains no expressions 	|
|    Passed    	| contains no failing case/expression 	|                              	| file contains empty `[]` form 	|
|    Skipped   	|        successfully skipped*        	|         ignored crash*       	|   file contains no `[]` form  	|

\* due to testing configuration

* Completed: when a case executes to completion; a group containing only completed cases is also *completed*
  * Failed: expression in a case doesn't run as specified; the case continues executing but is marked *failed*

  * Passed: all expressions in a given case, file, or directory ran as specified

  * Skipped: case contains `skip()` expression, or a file was skipped due to configuration

* Crashed: a case directly or indirectly calls `die`, `warn`, or a failing `assert*()`, stopping execution of the case expressions after the crash, and causing its group to also be marked *crashed*

  * F: default Result for a Crashed case or file; "Crashed+Failed" propagates up the stack like "Completed+Failed"

  * S: configuration specifies this file should have its crashes ignored

* Empty
  * F: case with no expressions and no `skip()`, like `Luciu("empty").go{}`, because entirely forgetting to call the test framework is a bug

  * P: an empty group `[ ]`

  * S: a file containing no `[ ]` form at all, which has no return value, and thus no meaning

A file without a `[ ]` form is not considered an error (unless specified by configuration), but a diagnostic is issued.

A group is Completed+Skipped when all of its cases call `skip()`, or when the configuration marks it to be skipped.

```
$ sidef luciu.sm tests/
How glossy is your Sidef?

Opening 'tests/'...
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
   SKIP Case 'empty_no_skip'

   TEST Case 'another_case'...
	PASS	says		'this shou...' ~~ '/shouldn'...'
   PASS Case 'another_case'

 Tested 'tests/again.st'
Finished 'tests/'.

Planned  2 Groups, 5 Cases, 28 Exprs

         Completed Crashed Empty
Passing  1 3 28            0 0 0
Failing  0 0 0     0 0 0   0 0 0
Skipping 1 2 0     0 0 0   0 0 0
         G C E     G C E   G C E

Found jewel-quality Sidef.
```