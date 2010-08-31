@f_tag
Feature: foo

  @wip   @s_tag
  Scenario: oh
    Given foo
    When bar
    Then blah

  @o_tag
  Scenario Outline: outline
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    Scenarios: another
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

    @e_tag

    Scenarios: yet
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

