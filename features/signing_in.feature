Feature: Signing in
  Scenario: Unsuccessful signin
    Given a user visits the sighin page
    When he submits invalid signin information
    Then he should see an error message

  Scenario: Successful signin
    Given a user visits the sighin page
      And the user has an accout
    When the user submits valid signin information
    Then he should see his profile page
      And he should see a signout link