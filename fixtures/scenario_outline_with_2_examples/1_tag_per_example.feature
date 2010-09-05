Feature: foo

  Scenario Outline: some
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    @wip
    Scenarios: another
      |foo|bar|fan|
      | 7 | 8 | 9 |
      | 0 | 1 | 2 |

    @smoke
    Scenarios: yet
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |
