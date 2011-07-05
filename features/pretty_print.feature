Feature: Pretty print report on 3 features

  @just_me
  Scenario: Tag report on everything in fixtures/self_test
    When I run cuporter --config-file features/support/cuporter.yml
    Then the output should have the same contents as "features/reports/pretty_with_outlines_and_examples.txt"
    
  Scenario: Tag report showing features without any tags
    When I run cuporter --config-file features/support/cuporter.yml -i fixtures/one
    Then the output should have the same contents as "features/reports/pretty_with_tagged_and_tagless.txt"
    
  Scenario: Unfiltered feature report on everything in fixtures/self_test
    When I run cuporter --config-file features/support/cuporter.yml -r feature
    Then the output should have the same contents as "features/reports/pretty_feature_report.txt"
    
  Scenario: Filtered feature report: excluding @wip
    When I run cuporter --config-file features/support/cuporter.yml -r feature -t ~@wip
    Then the output should have the same contents as "features/reports/pretty_filter_out_wip.txt"
    
  Scenario: Filtered feature report: including @wip
    When I run cuporter --config-file features/support/cuporter.yml -r feature -t @wip
    Then the output should have the same contents as "features/reports/pretty_filter_in_wip.txt"
    
  Scenario: Filtered feature report: Logical AND
    When I run cuporter --config-file features/support/cuporter.yml -r feature -t @wip -t @smoke
    Then the output should have the same contents as "features/reports/pretty_logical_and_filter.txt"
    
  Scenario: Filtered feature report: Logical OR
    When I run cuporter --config-file features/support/cuporter.yml -r feature -t @smoke,@wip
    Then the output should have the same contents as "features/reports/pretty_logical_or_filter.txt"
    
  Scenario: Filtered feature report: Logical OR and NOT
    When I run cuporter --config-file features/support/cuporter.yml -r feature -t ~@customer -t @smoke,@wip
    Then the output should have the same contents as "features/reports/pretty_compound_or_and_not_filter.txt"
    
  Scenario: Tree report on fixtures/self_test
    When I run cuporter --config-file features/support/cuporter.yml -r tree
    Then the output should have the same contents as "features/reports/pretty_tree_report.txt"

  Scenario: Tree report on fixtures/one
    When I run cuporter --config-file features/support/cuporter.yml -i fixtures/one -r tree
    Then the output should have the same contents as "features/reports/pretty_variable_depth_tree.txt"
    
