def process_object object_json
  ActiveRecord::Base.transaction do

    h = JSON.parse object_json.downcase.gsub(",]","]").gsub(",}","}").gsub("Ä","ä").gsub("Ö","ö").gsub("Å","å")
    p_noticed = false
    p = Product.find_or_initialize_by(pid: h["pid"].to_s, shop: h["shop"])
    p.name = h["name"]
    p.price = h["price"]
    p.url = h["url"]
    p.image_id = h["image_id"].to_s
    
    if p.new_record?
      p.full_categories = h["categories"].to_json
      p.detail_compatibility = h["details"].to_json
      #puts "Creating #{h["name"]}"
      p_noticed = true
      p.save!
    else
      begin
        fc = JSON.parse p.full_categories
        p.full_categories = (fc + h["categories"]).uniq.to_json
      rescue 
      end
      
      
      begin
        dc = JSON.parse p.detail_compatibility
        p.detail_compatibility = (dc + h["details"]).uniq.to_json
      rescue
      end
      if p.changed?
        p_noticed = true
        #puts "Updated #{h["name"]}, #{h["pid"]}"
        p.save!
      end
    end
    
    
      
    # Update up to two categories (but not deeper)
    h["categories"].each do |cat_list|
      unless cat_list.blank?
        c = Category.find_or_create_by!(name: cat_list[0])
        if cat_list.length > 0
    c1 = c.children.find_or_create_by!(name: cat_list[1])
        else
    c1 = c
        end
        unless p.categories.exists? c1
          p.categories << c1 
          #puts "Unchanged #{h["name"]}" unless p_noticed
          #puts "  => Added to category #{c1.name}"
        end
      end
    end
      
    
    # Update manufacturer and car model (but not deeper)
    h["compatibility"].each do |comp|
      # manufacturer
      manu = Manufacturer.find_or_create_by! name: comp["brand"]
      comp["models"].each do |model|
        model1 = manu.car_brands.find_or_create_by(name: model)
        unless p.car_brands.exists? model1
          p.car_brands << model1
          #puts "Unchanged #{h["name"]}" unless p_noticed
          #puts "  => added to #{manu.name} #{model1.name}"
        end
      end
    end
  end
end


def load_file f
  puts `date`
  puts "Processing #{f.basename}"
  object_json = ""

  File.open(f).each do |line|
    case line.strip
    when "[", "]"
      # skip these lines if no object
      object_json << line.strip unless object_json.blank?
    when "{"
      # start new object
      raise "previous object not completed" unless object_json.blank?
      object_json = line.strip
    when "},"
      # start new object
      raise "object closed with no content" if object_json.blank?
      object_json << line.strip
      process_object object_json.gsub(/,$/,"")
      object_json = ""
    else
      raise "object not opened properlystarted in line #{line}" if object_json.blank?
      object_json << line.strip
    end
  end
end


namespace :loader do
  desc 'loads a file or folder of jsons. invoke as rake loader:load["relative_path"]'
  task :load, [:path] => :environment do |t, args|
    f = Rails.root.join args[:path]
    if f.file?
      load_file f
    elsif f.directory?
      puts "Processing directory #{f.to_s}"
      Dir.new(f).entries.each do |g| 
	unless File.directory? g
  	  load_file(f.join g) 
	end
      end
    elsif
      puts "Cannot find path #{f}"
    end
  end
end