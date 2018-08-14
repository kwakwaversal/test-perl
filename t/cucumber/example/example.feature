@tag
Feature: Addition and subtraction

  In order to be considered a good counter I need to make sure that I am
  actually counting properly.

  Background:
    Given a brain
    And some food and water

  @subtag
  Scenario: add some numbers
    Given the number 5
    When you add the number 5
    Then the value is 10
