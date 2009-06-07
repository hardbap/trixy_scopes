# TrixyScopes

Collection of useful named scopes for rails apps.


## Examples

** limit

limits result to given number of records

<pre>
Product.limit(5)
# => SELECT * FROM `products` LIMIT 5
</pre>

**random**

<pre>
Product.random
# for SQLite adapter
# => SELECT * FROM `sites` ORDER BY RANDOM() LIMIT 3
# for MySql and other adapters:
# => SELECT * FROM `sites` ORDER BY RAND() LIMIT 3
</pre>

<pre>
Product.limit(3).random

</pre>

**latest**

<pre>
Product.latest(5)
</pre>

**earliest**

<pre>
Product.earliest(10)
</pre>

**after**

**before**

**in**

**not_in**

## Installation


script/plugin install git://github.com/tomaszmazur/trixy_scopes.git

in your ActiveRecord model:

<pre>
  class Product < ActiveRecord::Base
    ...
  
    include TrixyScopes
    
  end
</pre>
to gains access to following named_scopes:


## Copyright

Copyright (c) 2009 Tomasz Mazur, released under the MIT license
