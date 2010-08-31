@f_tag

Feature: feature number 3

  Scenario: 3 1
    Given blah
    When blah
    Then Blah

    @o_tag
  Scenario Outline: 3 2
    Given a big "<foo>"
    When I "<bar>"
    Then it takes a "<dump>" in the woods

    Examples: 3 2 1
      |foo|bar|dump|
      | 1 | 2 | 3  |
      | 4 | 5 | 6  |
    
    Examples: 3 2 2
      |foo|bar|dump|
      | 1 | 2 | 3  |
      | 4 | 5 | 6  |
    
    @customer
    Scenarios: 3 2 3
      |foo|bar|dump|
      | 1 | 2 | 3  |
      | 4 | 5 | 6  |

    @wip
    Examples: 3 2 4
      |foo|bar|dump|
      | 1 | 2 | 3  |
      | 4 | 5 | 6  |

  @s_tag
  Scenario: 3 3
    Given blah
    When blah
    Then Blah
