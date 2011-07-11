Feature: a feature saved with a bom

  Scenario: some test of something
    Given a windows machine
    And a certain editor setting
    Then this file could be saved with a byte order mark at the beginning

  @smoke
  Scenario: another test
    Given blah
    When blah
    Then blah
