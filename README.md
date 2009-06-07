# TrixyScopes

Collection of useful named scopes for rails apps.
Additional methods are generated based on column type and prefixed by column name:
ie: Product.name_is("ipod"), Product.price_is_greater_than(100)

Datetime columns ending with **_at** get also functional aliases:

Product.updated_at_before('2008-01-01') is equal to:
Product.updated_before('2008-01-01')


## Examples

**limit** - limits result to given number of records

<pre>
Product.limit(5)
# => SELECT * FROM `products` LIMIT 5
</pre>

**random** - adapter agnostic random

<pre>
Product.limit(3).random
# for SQLite adapter
# => SELECT * FROM `sites` ORDER BY RANDOM() LIMIT 3
# for MySql and other adapters:
# => SELECT * FROM `sites` ORDER BY RAND() LIMIT 3
</pre>

**latest** - picks up latest records (ordered by **created_at**)

<pre>
Product.latest
# => SELECT * FROM `products` ORDER BY `products`.`created_at` desc

Product.latest(5)
# => SELECT * FROM `products` ORDER BY `products`.`created_at` desc LIMIT 5
</pre>

**earliest** - picks up earliest records (ordered by **created_at**)

<pre>
Product.earliest(10)
# => SELECT * FROM `products` ORDER BY `products`.`created_at` asc LIMIT 10
</pre>

**after** - picks up records after given datetime

<pre>
Product.after(1.year.ago)
# => SELECT * FROM `products` WHERE (`products`.`created_at` > '2008-06-07 16:11:56') 
</pre>

**before** - picks up records before given datetime

<pre>
Product.before(Time.now.beginning_of_day)
# => SELECT * FROM `products` WHERE (`products`.`created_at` < '2008-06-07 00:00:00') 
</pre>

**in** - picks up records where with given array of ids

<pre>
Product.in(1,2,3)
Product.in([1,2,3])
# => SELECT * FROM `products` WHERE (`products`.`id` IN (1,2,3))
</pre>

**not_in** - picks up records that have ids other that given array

<pre>
Product.not_in(1,2,3)
# => SELECT * FROM `products` WHERE (`sites`.`id` NOT IN(1,2,3))
</pre>

## ALL column types

**<attribute_name>_is**

**<attribute_name>_is_not**

**<attribute_name>_is_nil**

**<attribute_name>_is_not_nil**


## STRING columns

**<attribute_name>_starts_with**

**<attribute_name>_ends_with**

**<attribute_name>_includes**

**<attribute_name>_matches**

**<attribute_name>_like**

**<attribute_name>_not_like**

## BOOLEAN

**<attribute_name>**

**not_<attribute_name>**

## DATETIME

**<attribute_name>_before**

**<attribute_name>_after**

**<attribute_name>_between**

**<attribute_name>_not_between**

## INTEGER, FLOAT

**<attribute_name>_greater_than**

**<attribute_name>_greater_or_equal_to**


**<attribute_name>_less_than**

**<attribute_name>_less_than_or_equal_to**




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
