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

**latest(<integer>)** - picks up latest records (ordered by **created_at**)

<pre>
Product.latest
# => SELECT * FROM `products` ORDER BY `products`.`created_at` desc

Product.latest(5)
# => SELECT * FROM `products` ORDER BY `products`.`created_at` desc LIMIT 5
</pre>

**earliest(<integer>)** - picks up earliest records (ordered by **created_at**)

<pre>
Product.earliest(10)
# => SELECT * FROM `products` ORDER BY `products`.`created_at` asc LIMIT 10
</pre>

**after(<datetime>)** - picks up records after given datetime

<pre>
Product.after(1.year.ago)
# => SELECT * FROM `products` WHERE (`products`.`created_at` > '2008-06-07 16:11:56') 
</pre>

**before(<datetime>)** - picks up records before given datetime

<pre>
Product.before(Time.now.beginning_of_day)
# => SELECT * FROM `products` WHERE (`products`.`created_at` < '2008-06-07 00:00:00') 
</pre>

**in(<array_of_ids>)** - picks up records where with given array of ids

<pre>
Product.in(1,2,3)
Product.in([1,2,3])
# => SELECT * FROM `products` WHERE (`products`.`id` IN (1,2,3))
</pre>

**not_in(<array_of_ids>)** - picks up records that have ids other that given array

<pre>
Product.not_in(1,2,3)
# => SELECT * FROM `products` WHERE (`sites`.`id` NOT IN(1,2,3))
</pre>

## ALL column types

**<attribute_name>_is(<attribute_value>)**

<pre>
Author.last_name_is("Smith")
# => SELECT * FROM `authors` WHERE (`authors`.`last_name` = 'Smith')

Product.price_is(19.99)
# => SELECT * FROM `products` WHERE (`products`.`price` = 19.99)
</pre>

**<attribute_name>_is_not(<attribute_value>)**

<pre>
Author.first_name_is_not("John")
# => SELECT * FROM `authors` WHERE (`authors`.`first_name` != 'John')

Product.price_is_not(1_000)
# => SELECT * FROM `products` WHERE (`products`.`price` != 1000)
</pre>

**<attribute_name>_is_nil**

<pre>
User.full_name_is_nil
# => SELECT * FROM `users` WHERE (`users`.`full_name` IS NULL) 
</pre>

**<attribute_name>_is_not_nil**

<pre>
Product.description_is_not_nil
# => SELECT * FROM `products` WHERE (`products`.`description` IS NOT NULL)
</pre>

## STRING columns

**<attribute_name>_starts_with**

<pre>
</pre>

**<attribute_name>_ends_with**

<pre>
</pre>

**<attribute_name>_includes**

<pre>
</pre>

**<attribute_name>_matches**

<pre>
</pre>

**<attribute_name>_like**

<pre>
</pre>

**<attribute_name>_not_like**

<pre>
</pre>

## BOOLEAN

**<attribute_name>**

<pre>
</pre>

**not_<attribute_name>**

<pre>
</pre>

## DATETIME

**<attribute_name>_before**

<pre>
</pre>

**<attribute_name>_after**

<pre>
</pre>

**<attribute_name>_between**

<pre>
</pre>

**<attribute_name>_not_between**

<pre>
</pre>

## INTEGER, FLOAT

**<attribute_name>_greater_than**

<pre>
</pre>

**<attribute_name>_greater_or_equal_to**

<pre>
</pre>

**<attribute_name>_less_than**

<pre>
</pre>

**<attribute_name>_less_than_or_equal_to**

<pre>
</pre>


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
