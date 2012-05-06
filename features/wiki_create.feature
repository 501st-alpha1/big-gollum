Feature: Users can create gollum wikis and browse them at their mountpoints

    Scenario: User creates a wiki
        When I create a wiki called "apple"
        Then I should see "apple" in the list of wikis
        When when I go to the "apple" wiki
        Then I should see "Apple Wiki"

    Scenario: User tries to create a wiki that already exists
        When I create a wiki called "apple"
        And I create a wiki called "apple"
        Then I should see "Could not create wiki."

    Scenario Outline: Invalid names for a wiki
        When I create a wiki called "<wiki_name>"
        Then I should see "Could not create wiki."
        And I should not see "<wiki_name>" in the list of wikis
        And the "<wiki_name>" wiki should not have a folder anymore

        Examples:
          | wiki_name |
          | asdf asdf |
          | asdf*#    |
          | AaA-A)()  |
