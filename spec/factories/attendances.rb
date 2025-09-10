FactoryBot.define do
  factory :attendance do
    date_on { Time.zone.local(2025, 9, 1) }
    start_time_at { Time.zone.local(2025, 9, 1, 9, 0) }
    finish_time_at { Time.zone.local(2025, 9, 1, 18, 0) }
    start_rest_time_at { Time.zone.local(2025, 9, 1, 12, 0) }
    finish_rest_time_at { Time.zone.local(2025, 9, 1, 13, 0) }
    association :user
  end
end
