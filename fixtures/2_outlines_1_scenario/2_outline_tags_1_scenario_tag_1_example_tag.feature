Feature: foo

  @s_o_tag_1
  Scenario Outline: outline 1
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    Scenarios: example
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

  @wip
  Scenario: oh
    Given foo
    When bar
    Then blah

  @s_o_tag_2
  Scenario Outline: outline 2
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

