Feature: Users can create gollum wikis and browse them at their mountpoints

    Scenario: User creates a wiki
        When I create a wiki called "apple"
        Then I should see "apple" in the list of wikis
        When when I go to the "apple" wiki
        Then I should see "Apple Wiki"

    Scenario: User deletes a wiki
        When I create a wiki called "apple"
        And I go to the list of wikis
        And I delete the "apple" wiki
        Then I should not see "apple"
        And the "apple" wiki should not have a folder anymore




