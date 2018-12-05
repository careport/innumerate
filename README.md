# innumerate
Set per-column statistics targets for PostgreSQL in Rails

In your ActiveRecord migrations, you can use:
```ruby
set_statistics_target users, email, 1000
```
... to set the statistics target of `users.email` to 1000. To make the
migration reversible, use the `old_target` option:
```ruby
set_statistics_target users, email, 1000, old_target: -1
```
Note that `-1` means "use the server's default statistics target."
