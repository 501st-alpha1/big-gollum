Feature: Users can navigate between gollum wikis
    Background:
        Given I am logged in as a user
        When I create a wiki called "apple"

    Scenario: User navigates back to wiki index
        When I visit the "apple" wiki
        And I click on the back to all wiki's button
        Then I should see "apple"
        And I should see "Logout"

    # Cleanup
        Then I delete the "apple" wiki
