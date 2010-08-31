Feature: foo

  Scenario Outline: outline
    Given a "<foo>"
    When I "<bar>"
    Then it all hits the "<fan>"

    Scenarios: another test
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |

    @smoke
    Scenarios: bang
      |foo|bar|fan|
      | 1 | 2 | 3 |
      | 4 | 5 | 6 |
