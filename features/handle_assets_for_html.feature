@teardown @html
Feature: handle CSS and JavaScript assets

  Scenario: assets are inlined for tag view by default
    Given output file "tmp/tag_view.html"
    When I run cuporter -f html -o tmp/tag_view.html
    Then the head element should not have "link" tags
    And the head element should have "style" tags of type "text/css"
    And the head element should have "script" tags of type "text/javascript" with no "src" attribute

  Scenario: assets are inlined for feature view by default
    Given output file "tmp/feature_view.html"
    When I run cuporter -r feature -f html -o tmp/feature_view.html
    Then the head element should not have "link" tags
    And the head element should have "style" tags of type "text/css"
    And the head element should have "script" tags of type "text/javascript" with no "src" attribute

  Scenario: Assets linked to gem path by default in tree view
    Given output file "tmp/tree_view.html"
    When I run cuporter -r tree -f html -o tmp/tree_view.html
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

  Scenario: Assets linked to gem path in tag view
    Given output file "tmp/tag_view.html"
    When I run cuporter -r tag -f html --link-assets -o tmp/tag_view.html
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

  Scenario: Assets linked to gem path in feature view
    Given output file "tmp/feature_view.html"
    When I run cuporter -r feature -f html --link-assets -o tmp/feature_view.html
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

# assets linked to relative path, sibling to html
## tree view, [NEW OPTION]
## tag view, -l [NEW OPTION]
## feature view, -l [NEW OPTION]
# tree view: assets always linked

  Scenario: Assets linked to relative path: tree view
    Given output directory "tmp"
    And output file "tmp/tree_view.html"
    When I run cuporter -r tree -f html --copy-assets -o tmp/tree_view.html
    Then dir "tmp/cuporter" should exist
    And "tmp/cuporter/**/*.js" files should exist
    And "tmp/cuporter/**/*.css" files should exist
    And the head element should have "link" tags of type "text/css" whose "href" is relative
    And the head element should have "script" tags of type "text/javascript" whose "src" is relative

  Scenario: Assets linked to gem path when the --output-file option is not used
    When I run cuporter -r tree -f html
    And save the output
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists

  Scenario: Assets linked to gem path when the --output-file option is not used for a tag report
    When I run cuporter -l -f html
    And save the output
    Then the head element should not have "style" tags
    And the head element should have "link" tags of type "text/css" whose "href" exists
    And the head element should have "script" tags of type "text/javascript" whose "src" exists
