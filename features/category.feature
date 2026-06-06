Feature: Category tags for filtering

Scenario: Happy Path - Filtering successfully by "school" category
Given I am a user on the todos index page
When I filter by category "school"
Then I should see todos tagged "school"

Scenario: Edge Case - Filtering by a category that does not exist
Give I am a user on the todos index page
When I filter by a category that does not exist
Then I should not see any todos