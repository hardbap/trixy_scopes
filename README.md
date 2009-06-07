TrixyScopes
===========

Collection of useful named scopes for rails apps.


Installation
============

script/plugin install git://github.com/tomaszmazur/trixy_scopes.git

in your ActiveRecord model:

include TrixyScopes

to gains access to following named_scopes:

Examples:

** limit
limits result to exact number of records

Product.limit(5)

**random**

Product.random
Product.limit(3).random

**latest**

Product.latest(5)

**earliest**

Product.earliest(10)

**after**

**before**

**in**

**not_in**




Copyright (c) 2009 [Tomasz Mazur], released under the MIT license