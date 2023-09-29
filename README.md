# sort
Elm library for manipulating sorters.

# examples
Sorting a struct:
```elm
person1 = { name : "Bob", age : 25 }
person2 = { name : "James", age : 25 }
person3 = { name : "Bob", age : 30 }

sorter = Sort.and (Sort.by .name Sort.string) (Sort.by .age Sort.int)

Sort.order sorter person1 person2
-- LT

Sort.order sorter person1 person3
-- LT

Sort.order sorter person2 person3
-- GT
```
Layering sorters with `all`:
```elm
tuple1 = (-1, 3.4)
tuple2 = (3, 2.8)
tuple3 = (-1, 8.9)

sorter = Sort.all [ Sort.by Tuple.first <| Sort.reverse Sort.int, Sort.by Tuple.second Sort.float ]

Sort.order sorter tuple1 tuple2
-- GT

Sort.order sorter tuple1 tuple3
-- LT

Sort.order sorter tuple2 tuple3
-- LT
```
