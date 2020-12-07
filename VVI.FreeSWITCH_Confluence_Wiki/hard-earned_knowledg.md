### add user

scripts/perl/add_user 1020  

scripts/perl/add_user add-users=1020-1029  

vi conf/dialplan/default.xml
```
<extension name="Local_Extension">
<condition field="destination_number"
expression="^(10[01][0-9])$">
```

```
<condition field="destination_number"
expression="^(10[012][0-9])$">
```

```
By default, Local_Extension has a regular expression that will match 1000, 1001, and so on up to 1019. After adding that number range, it is necessary to modify the regular expression to account for those new numbers. In our example, we added user IDs 1020 through 1029, so we need to match these. We use this regular expression:

^(10[012][0-9])$

This matches 1000 through 1029. Let's say we have added another block of user IDs with the range from 1030 to 1039. We can modify our regular expression to catch them as well:

^(10[0123][0-9])$
```


