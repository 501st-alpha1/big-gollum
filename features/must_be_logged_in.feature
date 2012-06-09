Feature: In order to do pretty much anything on the site
         I want users to be logged in

Scenario: Arriving at the site without being logged in
    When I visit Big Gollum
    Then I should see "Sign in"
