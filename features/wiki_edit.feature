Feature: Users can edit gollum wikis
    Background:
        Given I am logged in as a user
        When I create a wiki called "apple"

    Scenario: User edits a wiki
        When I go to the list of wikis
        Then I should see "apple" in the list of wikis
        When I edit a wiki called "apple" and name it "pear"
        Then I should see "pear" in the list of wikis
        And I should not see "apple" in the list of wikis

    # Cleanup
        Then I delete the "pear" wiki
