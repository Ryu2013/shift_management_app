FactoryBot.define do
  factory :client_need do
    association :client

    week { :monday }
    shift_type { :day }
    start_time { "09:00" }
    end_time   { "17:00" }
    slots      { 1 }
  end
end
