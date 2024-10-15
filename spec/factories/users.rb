FactoryBot.define do
  factory :user do
    first_name { "Second" }
    last_name { "Rebaza" }
    email { "example@example.com" }
    role { "admin" }
    password { "password" }
  end
end
