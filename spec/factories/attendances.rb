FactoryBot.define do
  factory :attendance do
    date_on { Time.zone.local(2025, 9, 1) }
    started_at { Time.zone.local(2025, 9, 1, 9, 0) }
    finished_at { Time.zone.local(2025, 9, 1, 18, 0) }
    started_rest_at { Time.zone.local(2025, 9, 1, 12, 0) }
    finished_rest_at { Time.zone.local(2025, 9, 1, 13, 0) }
    association :user
  end
end
