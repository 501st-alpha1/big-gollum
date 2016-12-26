Feature: Users can sign up when registrations are enabled
    Background:
        Given registrations are "enabled"

    Scenario: Successful sign up
        When I am on the sign up page
        Then I should see "Sign up"
        And I register as "test@example.com"
        Then I should see "Welcome! You have signed up successfully."

    # Clean up
        Then I should delete user "test@example.com"
