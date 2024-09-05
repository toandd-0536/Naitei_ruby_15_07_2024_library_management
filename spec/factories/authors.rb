FactoryBot.define do
  factory :author do
    name {Faker::Book.author}
    intro {Faker::Lorem.sentence}
    bio {Faker::Lorem.paragraph}
    dob {Faker::Date.birthday(min_age: 18, max_age: 65)}
    dod {nil}

    after(:create) do |author|
      author.thumb_img.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "sample_image.png")),
        filename: "sample_image.png",
        content_type: "image/png"
      )
    end
  end
end
