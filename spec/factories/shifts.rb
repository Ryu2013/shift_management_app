FactoryBot.define do
  factory :shift do
    office { nil }
    client { nil }
    date { "2025-09-15" }
    kind { 1 }
    slots { 1 }
    note { "MyString" }
  end
end
