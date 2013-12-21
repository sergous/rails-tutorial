FactoryGirl.define do
  factory :user do
    sequence(:name)   { |n| "Person #{n}" }
    sequence(:email)  { |n| "person_#{n}@example.com" }
    password  "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

    factory :user2 do
      name      "Example User"
      email     "user@example.com"
    end

    factory :user3 do
      name      "New Name"
      email     "new@example.com"
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end