FactoryBot.define do
  factory :client_need do
    association :client

    week { :monday }
    shift_type { :day }
    start_time { "09:00" }
    end_time   { "17:00" }
    slots      { 1 }

    # office を引数で渡された場合でも、client と同じ office に揃える
    after(:build) do |client_need|
      if client_need.office && client_need.client
        client_need.client.office = client_need.office
      elsif client_need.client&.office
        client_need.office ||= client_need.client.office
      else
        client_need.client ||= build(:client)
        client_need.office ||= client_need.client.office
      end
    end
  end
end

