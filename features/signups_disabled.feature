Feature: Users can't sign up when registrations are disabled
    Background:
        Given registrations are "disabled"

    Scenario: Load disabled sign up page
        When I am on the sign up page
        Then I should see "New sign ups are not allowed."

    Scenario: POST to disabled sign up page
        When I submit a new signup
        Then I should see "New sign ups are not allowed."
