Feature: foo

  @s_tag
  Scenario: oh
    Given foo
    When bar
    Then blah

  Scenario Outline: outline
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    @s_o_tag
    Scenarios: another
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

    Scenarios: yet
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

