FactoryBot.define do
  factory :travel_tip do
    city { "MyString" }
    marathon { "MyString" }
    itinerary { "MyText" }
    case_study { "MyText" }
    sentiment { "MyString" }
    source_url { "MyString" }
  end
end
