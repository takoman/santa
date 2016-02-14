santa
====

This is a Grape + Rack ([Gris](http://github.com/dylanfareed/gris)) hypermedia API service.


Set-Up for Development
---

- Fork this repo
- Clone your fork locally
- Bundle
```
cd your-fork-directory
bundle
```
- Set up the database
```
RACK_ENV=test bundle exec rake db:create
RACK_ENV=test bundle exec rake db:migrate
```
- Verify that [Rubocop](https://github.com/bbatsov/rubocop) and specs pass.
```
bundle exec rake
```
