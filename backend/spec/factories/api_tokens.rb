FactoryBot.define do
  factory :api_token do
    association :user
    token { SecureRandom.hex(32) }
    last_used_at { Time.current }
  end
end

