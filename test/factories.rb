FactoryGirl.define do
  factory :user do       |user|
    user.full_name              "ofer"
    user.email                  "ofer@gmail.com"
    user.password               "foobar"
    user.password_confirmation  "foobar"
  end
end