Santa
====
Develop [![Circle CI](https://circleci.com/gh/takoman/santa/tree/develop.svg?style=svg&circle-token=1d346c8e80582ca19250f0ebc068e33ad89c0284)](https://circleci.com/gh/takoman/santa/tree/develop), Master [![Circle CI](https://circleci.com/gh/takoman/santa/tree/master.svg?style=svg&circle-token=1d346c8e80582ca19250f0ebc068e33ad89c0284)](https://circleci.com/gh/takoman/santa/tree/master)

Santa is Pickee's main API. It is a Grape + Rack ([Gris](http://github.com/artsy/gris)) hypermedia API service.

Set-Up for Development
---

- Fork this repo
- Clone your fork locally
- Bundle
```
cd santa
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
