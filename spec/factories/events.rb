FactoryBot.define do
  factory :event do
    start_time { DateTime.current }
    end_time { DateTime.current + 2.hours }
    title { "Event Title" }
    description { "Event Description" }
    category { "Event Category" }
  end
end
