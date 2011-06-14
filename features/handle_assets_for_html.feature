@html
Feature: handle CSS and JavaScript assets

  Scenario: assets are inlined for tag view by default
    When I run cuporter -f html
    Then the head element should not have "link" tags
    And the head element should have "style" tags of type "text/css"
    And the head element should have "script" tags of type "text/javascript" with no "src" attribute

  Scenario: assets are inlined for feature view by default
    When I run cuporter -r feature -f html
    Then the head element should not have "link" tags
    And the head element should have "style" tags of type "text/css"
    And the head element should have "script" tags of type "text/javascript" with no "src" attribute

  Scenario: Assets linked to gem path by default in tree view
    When I run cuporter -r tree -f html
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

  Scenario: Assets linked to gem path in tag view
    When I run cuporter -r tag -f html --link-assets
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

  Scenario: Assets linked to gem path in feature view
    When I run cuporter -r feature -f html --link-assets
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

  @teardown
  Scenario Outline: Assets linked to relative path
    Given output directory "tmp"
    When I run cuporter -r <report> -f html -o <output_file> --copy-public-assets
    Then dir "tmp/cuporter_public" should exist
    And "tmp/cuporter_public/**/*.js" files should exist
    And "tmp/cuporter_public/**/*.css" files should exist

    When I read file "<output_file>"
    Then the head element should have "link" tags of type "text/css" whose "href" begins "cuporter_public/"
    And  the head element should have "script" tags of type "text/javascript" whose "src" begins "cuporter_public/"

    Examples:
      | output_file           | report     |
      | tmp/tree_view.html    | tree       |
      | tmp/tag_view.html     | tag -l     |
      | tmp/feature_view.html | feature -l |
