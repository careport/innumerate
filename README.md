# innumerate
Adds support for per-column statistics targets and reloptions
to the Rails schema.rb file.

(The name "innumerate" was chosen when the library only
supported statistics targets. It was a weak joke at the
time, and now the name makes so sense at all. C'est la vie.)

In your ActiveRecord migrations, you can use:
```ruby
set_statistics_target :users, :email, 1000
```
... to set the statistics target of `users.email` to 1000. To make the
migration reversible, use the `old_target` option:
```ruby
set_statistics_target :users, :email, 1000, old_target: -1
```
Note that `-1` means "use the server's default statistics target."

You can also set a table's [reloptions](https://github.com/postgres/postgres/blob/master/src/backend/access/common/reloptions.c)
with:
```ruby
set_reloptions :users, {
  fillfactor: 70,
  autovacuum_vacuum_insert_threshold: 40000
}
```

There is also a version that only sets a single reloption:
```ruby
set_reloption :users, :fillfactor, 70
```
(This is the version used in the schema.rb file, since it will
remain tidy, even if you add many reloptions to a single table.)

Reloption changes are not currently invertable.
