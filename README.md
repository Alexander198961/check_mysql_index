To run script use
perl message_data.cfg user_credentials.cfg
if your database key primary  has type that should be extended  the script will notify you
for example:
if we have type int ("int" => 2147483647) for primary key and it is auto increment and we will have large table size for exaple 2007483647 script alert us that we should overload table
Script gives this output:
max size of int unsigned = 4294967295
 column  contains  3980644270 rows
Difference between size of int unsigned - table rows  =314323025

percent size captured (int unsigned/rows)0.926815967756979
Overload it!!!!!=====================================================
  
