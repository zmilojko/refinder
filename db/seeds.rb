Dir[Rails.root.join('db/seeds/*.rb')].sort.each { |file| load file }
