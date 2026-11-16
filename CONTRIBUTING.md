# How to Contribute

## Information first

Before starting on a feature or a bug, please tell the community about it. Simply create an issue on the github Issue Tracker.
Describe the issue in a few words, for example what the error is or what feature you have in mind.
So everybody knows about the problem/feature and that someone is working on it.

## Creating a pull request

* Create a github account if you don't have one already.
* Fork our master branch into your github account.
* Make a feature branch for your change.
* Do your thing.
* Don't forget the tests!
* Open a pull request on the github site.
* If the automatic test are fine, we will merge
* If they are failing, please fix them!

If you plan to do a complex change, it may be good to create a pull request before you are done. So the others can see what
you are planning and maybe correct the trajectory if needed.

## Coding conventions

TDB

## Testing

If you add new features, add new tests for them. If you change something, adapt the tests to the fix, if needed.

### rspec-puppet

To run the rspec-puppet tests for this module install the needed gems with [bundler](http://bundler.io):

     bundle install --path=vendor

And run the tests and puppet-lint:

     bundle exec rake

### Acceptance Tests

Acceptance tests use [Litmus](https://github.com/puppetlabs/puppet_litmus)
and a local Vagrant VM. They must not be run against production OpenNebula.

See [TESTING.md](TESTING.md) for the full procedure, including Vagrant,
the Litmus inventory and the smoke test.

### Legacy Beaker tests

The old Beaker specs are kept in `spec/legacy_acceptance/` for future
rewriting. They are not executed.

### Docker

The `docker/` directory contains an AlmaLinux 8 smoke-test image with Puppet 8.
See [TESTING.md](TESTING.md) for the container workflow.