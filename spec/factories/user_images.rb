# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_image do
    content "MyString"
    user_id 1
  end
end
