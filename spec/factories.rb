FactoryGirl.define do
  factory :user do
    name      "Test User"
    email     "test@example.com"
    password  "foobar"
    password_confirmation "foobar"

    factory :user2 do
      name      "Example User"
      email     "user@example.com"
    end
  end
end