Feature: Pretty print report on 3 features

  @just_me
  Scenario: Tag report on everything in fixtures/self_test
    When I run cuporter --in fixtures/self_test
    Then the output should have the same contents as "features/reports/pretty_with_outlines_and_examples.txt"
    
  Scenario: Unfiltered feature report on everything in fixtures/self_test
    When I run cuporter --in fixtures/self_test -r feature
    Then the output should have the same contents as "features/reports/pretty_feature_report.txt"
    
  Scenario: Filtered feature report: excluding @wip
    When I run cuporter --in fixtures/self_test -r feature -t ~@wip
    Then the output should have the same contents as "features/reports/pretty_filter_out_wip.txt"
    
  Scenario: Filtered feature report: including @wip
    When I run cuporter --in fixtures/self_test -r feature -t @wip
    Then the output should have the same contents as "features/reports/pretty_filter_in_wip.txt"
    
  Scenario: Filtered feature report: Logical AND
    When I run cuporter --in fixtures/self_test -r feature -t @wip -t @smoke
    Then the output should have the same contents as "features/reports/pretty_logical_and_filter.txt"
    
  Scenario: Filtered feature report: Logical OR
    When I run cuporter --in fixtures/self_test -r feature -t @smoke,@wip
    Then the output should have the same contents as "features/reports/pretty_logical_or_filter.txt"
    
  Scenario: Filtered feature report: Logical OR and NOT
    When I run cuporter --in fixtures/self_test -r feature -t ~@customer -t @smoke,@wip
    Then the output should have the same contents as "features/reports/pretty_compound_or_and_not_filter.txt"
    
