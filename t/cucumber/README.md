# Cucumber in Perl
How [Cucumber] is utilised within this repo

# Synopsis

```bash
# Pretty output (errors are inlined with the specific scenario step)
$ pherkin -l t/cucumber

# Test specific tag(s) to speed up testing iterations
$ pherkin -l -t @tag t/cucumber

# Test subtags for a specific tag(s) for more test precision
$ pherkin -l -t @tag -t @subtag t/cucumber

# If you get the error `Not an ARRAY reference` use prove as outlined below. It
# seems to be a problem with the stack trace. The TAP source handler will
# display the error properly.
```

```bash
# TAP output (best used for CI testing)
$ prove -l t/cucumber.t
```

# Description

Using [BDD] in [Perl] is made easy with [Test::BDD::Cucumber]. There are a few
gotchas when using it but not enough for it not to be incredibly useful. If you
get the error `Not an ARRAY reference` just use prove.

[Cucumber] `.feature` files need to be placed in the appropriate folder
(`./t/cucumber` in this example). It makes sense to group features into related
subdirectories and try and make your steps as consistent as possible for code
reuse.

Every feature directory has their step definitions placed in the subdirectory
`./t/cucumber/{dir}/step_definitions`. The name of the files are not important
as every file is read in and the step definitions are available to any
features in `./t/cucumber/{dir}`.

# Examples

```gherkin
# Comment
@tag
Feature: Eating too many cucumbers may not be good for you

  Eating too much of anything may not be good for you.

  @subtag
  Scenario: Eating a few is no problem
    Given Alice is hungry
    When she eats 3 cucumbers
    Then she will be full
```

# References

* [BDD]
* [BDD overview](http://docs.cucumber.io/bdd/overview/)
* [Cucumber]
* [Perl]
* [Test::BDD::Cucumber]

[BDD]: https://en.wikipedia.org/wiki/Behavior-driven_development
[Cucumber]: https://cucumber.io
[Perl]: https://perl.org
[Test::BDD::Cucumber]: https://metacpan.org/pod/Test::BDD::Cucumber
