FactoryBot.define do
  factory :client do
    office { nil }
    name { "MyString" }
    email { "MyString" }
    address { "MyString" }
    note { "MyText" }
  end
end
