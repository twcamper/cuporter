Feature: foo

  @s_o_tag_1
  Scenario Outline: outline 1
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

		@nameless
    Scenarios: 
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

    Scenarios: example set 2
      |foo|bar|fan|
      | 5 | 6 | 7 |
      | 8 | 9 | 0 |


  Scenario: oh
    Given foo
    When bar
    Then blah

  @s_o_tag_2
  Scenario Outline: outline 2
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    Examples: another
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

    @e_tag
    Examples:
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

