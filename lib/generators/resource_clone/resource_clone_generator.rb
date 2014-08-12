#rails g resource_clone cloned_person person

class ResourceCloneGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  #main argument is clone name
  argument :source_model, type: :string, default: nil, banner: "source_model model"
  class_option :test_mode, :type => :boolean, :default => false, :desc => "Skip db:migration"
  check_class_collision # no suffix for model
  check_class_collision suffix: "Controller"
  #not sure it works for modules
  check_class_collision suffix: "Helper"
  check_class_collision suffix: "Test"
  check_class_collision suffix: "Spec"

  def check_for_model
    begin
    source_model.classify.constantize #throws runtime if model doesn't exist
    rescue
      raise Thor::Error, 
        "Cannot clone model (#{source_model}) that doesn't exist."
    end
  end

  def handle_model
  	base_path = "app/models"
    path = File.join(base_path, "#{file_name}.rb")
    copy_file("#{Rails.root}/app/models/#{source_model}.rb", path)
    gsub_file path, source_model.classify, class_name
    #replace other uses of source_model here??? (should be using "self")
  end

  def handle_controller
  	base_path = "app/controllers"
    path = File.join(base_path, "#{file_name.pluralize}_controller.rb")
    copy_file("#{Rails.root}/app/controllers/#{source_model.pluralize}_controller.rb", path)
    gsub_file path, source_model.classify.pluralize, class_name.pluralize
    gsub_file path, source_model.classify, class_name
    gsub_file path, "@#{source_model.pluralize} =", "@#{table_name} ="
    gsub_file path, "@#{source_model} =", "@#{file_name} ="
    gsub_file path, ":#{source_model}", ":#{file_name}"
    gsub_file path, "def #{source_model}_params", "def #{file_name}_params"
  end

  def handle_views
  	base_path = "app/views/#{file_name.pluralize}"
  	directory "#{Rails.root}/app/views/#{source_model.pluralize}", base_path
  	gsub_file "#{base_path}/index.html.haml", "@#{source_model.pluralize}.", "@#{file_name.pluralize}."
  	gsub_file "#{base_path}/index.html.haml", %r((\s)#{source_model.humanize.pluralize}(\s)), 
  							"+#{'\1'+file_name.humanize.pluralize+'\2'}"
  	gsub_file "#{base_path}/index.html.haml", %r(link_to (.*), edit_#{source_model}_path\(#{source_model}\)), 
  		"link_to #{'\1'}, edit_#{file_name}_path(#{file_name})"
  	gsub_file "#{base_path}/index.html.haml", %r(link_to (.*), #{source_model}), "link_to #{'\1'}, #{file_name}"
  	gsub_file "#{base_path}/index.html.haml", %r(link_to (.*), new_#{source_model}_path), 
  		"link_to #{'\1'}, new_#{file_name}_path"
  	gsub_file "#{base_path}/_form.html.haml", %r(@#{source_model}(\s)), "@#{file_name+'\1'}"
  	#TODO: DRY up
  	gsub_file "#{base_path}/edit.html.haml", %r(#{source_model.humanize}(\s)), "#{file_name.humanize+'\1'}"
  	gsub_file "#{base_path}/new.html.haml", %r(#{source_model.humanize}(\s)), "#{file_name.humanize+'\1'}"
  end

  def handle_migration
  	migr_files = Dir["#{Rails.root}/db/migrate/*_create_#{source_model.pluralize}.rb"]
  	if migr_files.count > 0
  		@ts = Time.now.to_s(:number)
  		@new_migr_file = "#{@ts}_create_#{table_name}.rb"
  		copy_file migr_files.first, "db/migrate/#{@new_migr_file}"
  		gsub_file "db/migrate/#{@new_migr_file}", 
  			"class Create#{source_model.classify.pluralize} < ActiveRecord::Migration",
  			"class Create#{table_name.classify.pluralize} < ActiveRecord::Migration"
  	  gsub_file "db/migrate/#{@new_migr_file}", "create_table :#{source_model.pluralize} do |t|",
  	  	"create_table :#{table_name} do |t|"
  	end
  end

  def handle_routes
  	lines = File.readlines("#{Rails.root}/config/routes.rb")

  	#TODO: Make sure this works when multiple resources are defined on the same line
  	# ie. resources :photos, :books, :videos
  	rsrc_routes = lines.select { |line| line.match(%r(resources :#{source_model.pluralize})) }
  	routes_str = rsrc_routes.inject("") do |memo, route|
  		memo << route.gsub(%r(resources :#{source_model.pluralize}), "resources :#{table_name}")+"\n"
  	end
  	inject_into_file "config/routes.rb",
  		after: ".application.routes.draw do\n" do
  			routes_str
  		end
  	
  	re = %r((\A\s*[get|post|put|patch|delete].*)#{source_model.pluralize}([/|#]))
  	method_routes = lines.select { |line| line.match(re) }
  	routes_str = method_routes.inject("") do |memo, route|
  		#memo << route.gsub(re, "#{'\1'+file_name.pluralize+'\2'}")
  		# above line didn't work for get '/people/:id' => 'people#show'
  		# so for now just replace old resource with new
  		memo << route.gsub(source_model.pluralize, file_name.pluralize)
  	end
  	inject_into_file "config/routes.rb",
  		after: ".application.routes.draw do\n" do
  			"\n"+routes_str
  		end
  end

  def handle_tests
  	#???
  end

  def handle_assets
  	#???
  end

  def handle_messages
  	unless behavior == :revoke || options.test_mode?
	  	msg = "\nRun new migration [#{@new_migr_file}] now "
	  	msg +=	" by typing 'y' or type 'n' and run it later at your liesure."
	  	if yes?(msg, :magenta)
	  		rake "db:migrate:up VERSION=#{@ts}"
	  	end
	  end
  end

end


########Resources items left to (possibly) clone########

# invoke    test_unit
# create      test/models/person_test.rb
# create      test/fixtures/people.yml
#invoke  test_unit
#create    test/controllers/people_controller_test.rb
#invoke  helper
#create    app/helpers/people_helper.rb
#invoke    test_unit
#create      test/helpers/people_helper_test.rb
#invoke  assets
#invoke    js
#create      app/assets/javascripts/people.js
#invoke    css
#create      app/assets/stylesheets/people.css
