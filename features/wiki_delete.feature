Feature: As a user
         In order to delete a wiki
         I want to have a link or button where I can do that

Background:
    Given I am logged in as a user

  Scenario: User deletes a wiki
        When I create a wiki called "apple"
        And I create a wiki called "banana"
        And I go to the list of wikis
        And I delete the "apple" wiki
        Then I should not see "apple"
        And I should see "banana"
        And the "apple" wiki should not have a folder anymore

        When I delete the "banana" wiki
        Then I should not see "banana"
        And the "banana" wiki should not have a folder anymore