require 'faker'

Rake::Task['db:reset'].invoke

def create_user
  5.times do |n|
      User.create!(
          username: Faker::Name.name,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: "example-#{n+1}@gymshare.com",
          password: "motdepasse",
          is_public: true
      )
  end

  users = User.all.sample(3)
  3.times do
    content = Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4)
    users.each do |user|
      Post.create!(user: user, postable: Status.new(text: content)) 
    end
  end
  create_gyms
  make_connects
end

def create_gyms
  users = User.all.sample(3)
  data = JSON.parse(IO.read(Rails.root + "app/assets/datasets/data-es.json"))
  i = 0

  users.each do |customer|
    prospect = (users - [customer]).sample
    data.each do |c|
      if i == 10
        i = 1
      else
        i = i + 1
      end

      gymhouse = Gymhouse.create!( 
        name: c["fields"]['nominstallation'],
        address1: c["fields"]['adresse'],
        address2: Faker::Address.secondary_address,
        headline: c["fields"]['atlas'],
        postal:  c["fields"]['codepostal'],
        country: "France",
        state: c["fields"]['nom_region'],
        city: c["fields"]['commune'],
        customer_id:  customer.id,
        prospect_id:  prospect.id,
        description: Faker::Lorem.paragraphs(number: 30).join(" "),
        price: Money.from_amount((25..100).to_a.sample)
      )
      gymhouse.avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "gymhouse_#{i}.jpg")), filename: gymhouse.name)
    end
  end
end

def make_connects
  Connect.delete_all  # suppression de la table micropost
  Connect.reset_pk_sequence # remise de l'id à 1 pour table micropost
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

create_user
