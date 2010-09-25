Feature: Pretty print report on 3 features

  @just_me
  Scenario: Tag report on everything in fixtures/self_test
    When I run cuporter --in fixtures/self_test
    Then the output should have the same contents as "features/reports/pretty_with_outlines_and_examples.txt"
    
  Scenario: Name report on everything in fixtures/self_test
    When I run cuporter --in fixtures/self_test -r name
    Then the output should have the same contents as "features/reports/pretty_name_report.txt"
    
