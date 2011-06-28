@teardown @html
Feature: output a report in multiple formats

  Scenario: two formats but one output file
    Given output directory "tmp"
    When I run cuporter --i fixtures/self_test --no-number --no-total --no-show-files --no-show-tags -f html -f text -o tmp/tags.html
    Then the output should have the same contents as "features/reports/pretty_with_outlines_and_examples.txt"
    But file "tmp/tags.txt" should not exist

    When I read file "tmp/tags.html"
    Then it should have ".tag" nodes

  Scenario: four formats four output files all exist
    Given output directory "tmp"
    When I run cuporter -f html -f csv -f text -f xml -o tmp/tags.csv -o tmp/tags.txt -o tmp/tags.xml -o tmp/tags.html

    Then file "tmp/tags.html" should exist
    And it should end with "</html>"
    
    Then file "tmp/tags.xml" should exist
    And it should end with "</xml>"

    Then file "tmp/tags.txt" should exist
    And it should end with "output file"
    
    Then file "tmp/tags.csv" should exist
    And it should end with "output file,"
