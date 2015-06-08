Feature: Users can edit pages of wiki
    Background:
        Given I am logged in as a user
        When I create a wiki called "apple"

    Scenario: User edits page of a wiki
        When I go to the list of wikis
        Then I should see "apple" in the list of wikis
        When I visit the "apple" wiki
        And I edit the wiki page
        Then the last edited info should be "Jack Johnson"
