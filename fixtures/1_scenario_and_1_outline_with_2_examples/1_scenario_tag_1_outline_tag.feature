Feature: foo

  @s_tag
  Scenario: oh
    Given foo
    When bar
    Then blah

  @s_o_tag
  Scenario Outline: outline
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    Scenarios: another
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

    Scenarios: yet
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

