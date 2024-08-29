FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    phone {Faker::PhoneNumber.cell_phone}
    address {Faker::Address.full_address}
    dob {Faker::Date.birthday(min_age: 18, max_age: 65)}
    password {"password"}
    role {0}
    lost_time {0}
    blacklisted {false}
    activated {true}
    encrypted_password {Devise::Encryptor.digest(User, "password")}
  end
end
