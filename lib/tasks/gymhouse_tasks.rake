#json data have been retrieve from https://equipements.sports.gouv.fr/explore/dataset/data-es/table/
require 'json'
require 'faker'

namespace :gymhouse_tasks do
  desc "Populate gymhouse database"
  task :populate => :environment do 
    Rake::Task['db:reset'].invoke
    create_reservation
  end
end

def create_reservation
  file = File.open Rails.root + "app/assets/datasets/data-es.json"
  data = JSON.load file
  file.close
  i = 0
  data.each do |c|
    i = i + 1
    test = c["recordid"]
    puts test
    #  gold_sentiment_dataset.data_points.create!(input: review['reviewText'], classification: review['classification'])
    gymhouse = Gymhouse.create!( 
      name: c["fields"]['nominstallation'],
      address1: c["fields"]['adresse'],
      address2: Faker::Address.secondary_address,
      headline: c["fields"]['atlas'],
      postal:  c["fields"]['codepostal'],
      country: "France",
      state: c["fields"]['nom_region'],
      city: c["fields"]['commune'],
      description: Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4)
    )
    gymhouse.avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "gymhouse_#{i}.jpg")), filename: gymhouse.name)
  end
end