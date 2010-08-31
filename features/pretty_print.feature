Feature: Pretty print report on 3 features

  @just_me
  Scenario: Everything in fixtures/self_test
    When I run cuporter --in fixtures/self_test
    Then the output should have the same contents as "features/reports/pretty_with_outlines.txt"
    
