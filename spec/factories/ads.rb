FactoryBot.define do
  factory :ad do
    headline { "MyString" }
    body { "MyString" }
    description { "MyString" }
    network { 1 }
    data { "" }
    cta { "MyString" }
    url { "MyString" }
    ad_type { "MyString" }
    source { "MyString" }
    launch_date { "MyString" }
    external_library_id { "MyString" }
    brand { nil }
    competitor { nil }
  end
end
