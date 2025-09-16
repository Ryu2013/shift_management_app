FactoryBot.define do
  factory :shift_member do
    office { nil }
    shift { nil }
    employee { nil }
    is_escort { false }
    work_status { 1 }
    start_time { "2025-09-15 07:47:04" }
    end_time { "2025-09-15 07:47:04" }
  end
end
