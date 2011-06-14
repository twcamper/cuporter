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

# assets linked to relative path, sibling to html
## tree view, [NEW OPTION]
## tag view, -l [NEW OPTION]
## feature view, -l [NEW OPTION]
# tree view: assets always linked

  @teardown
  Scenario: Assets linked to relative path: tree view
    Given output directory "tmp"
    When I run cuporter -r tree -f html --copy-assets
    Then dir "tmp/cuporter" should exist
    And "tmp/cuporter/**/*.js" files should exist
    And "tmp/cuporter/**/*.css" files should exist
    And the head element should have "link" tags of type "text/css" whose "href" begins "tmp/cuporter/"
    And the head element should have "script" tags of type "text/javascript" whose "src" begins "tmp/cuporter/"

