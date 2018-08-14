# test-perl
Testing [Perl] (a.k.a., reminding myself about Perl)

# Synopsis

```
$ prove -l -r
```

# Description
Tests vanilla Perl as well as different Perl modules to help my understanding
and provide myself with a future reference. Rather than creating one-off
scripts to scratch an itch, I will try and properly organise everything inside
this repository.

Also includes [BDD] testing using Perl's implementation of [Cucumber].
[Cucumber] is an expressive way to describe and test features and works quite
well using [Test::BDD::Cucumber]. It's intended to be a `single source of
truth` where the specifications, tests and documentation are in the `same
document`.

# Partially covered distributions
* [Moo](https://p3rl.org/Moo)
* [Test::BDD::Cucumber]

# See also
* [Perl]

[BDD]: https://en.wikipedia.org/wiki/Behavior-driven_development
[Cucumber]: https://cucumber.io
[Perl]: https://perl.org
[Test::BDD::Cucumber]: https://metacpan.org/pod/Test::BDD::Cucumber
