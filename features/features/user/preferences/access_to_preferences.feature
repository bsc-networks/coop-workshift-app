Feature: Workshift Manager: Set User Access to Preference Page 
  As a workshift manager
  In order to provide a way to stop users from editing their preferences
  I would like to be able to turn on and off their ability to edit
  
  Background:
    Given the following users exist:
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    And I am the following user:
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Ryan            | Riddle        | ry@berkeley.edu           |   hare         |      2           |
    And I am logged in as an admin
    And I am on my profile page
  
  @wip  
  Scenario: I take away everyone's ability to access the form
    Then I should see "Select Workshifts Preferences"
    When I follow "View & Edit Users"
    And I follow "Open Workshift Preference Form for Everyone" 
    Then I should see "true"
    When I click "Close Workshift Preference Form for Everyone"
    Then I should see "false"
    When I follow "Giorgia Willits"
    Then I should see "false"
    When I go to my profile page
    Then I should not see "Select Workshifts Preference"
  
  @wip  
  Scenario: I give everyone the ability to access the form
    When I follow "View & Edit Users"
    And I follow "Open Workshift Preference Form for Everyone"
    Then I should see "true"
    When I go to my profile page
    Then I should see "Select Workshifts Preference"
  
  @wip  
  Scenario: I take away one person's access to the form
    When I follow "View & Edit Users"
    And I follow "Open Workshift Preference Form for Everyone"
    When I follow "Eric Nelson"
    And I follow "Toggle Preference Form for Eric Nelson"
    Then I should see "false"
    When I follow "Giorgia Willits"
    Then I should see "true"