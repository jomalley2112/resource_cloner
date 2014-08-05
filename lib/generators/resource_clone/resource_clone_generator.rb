#rails g resource_clone cloned_person person

class ResourceCloneGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  #main argument is clone name
  argument :source_model, type: :string, default: nil, banner: "source_model model"
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
  	#TOD: DRY up
  	gsub_file "#{base_path}/edit.html.haml", %r(#{source_model.humanize}(\s)), "#{file_name.humanize+'\1'}"
  	gsub_file "#{base_path}/new.html.haml", %r(#{source_model.humanize}(\s)), "#{file_name.humanize+'\1'}"
  end

  def handle_routes
  	
  end

  def handle_migration
  	
  end

  def handle_tests
  	#???
  end

  def handle_assets
  	#???
  end

end

# invoke  active_record
# create    db/migrate/20140804165241_create_people.rb
# create    app/models/person.rb
# invoke    test_unit
# create      test/models/person_test.rb
# create      test/fixtures/people.yml
# route  get 'people/destroy'
# route  get 'people/update'
# route  get 'people/create'
# route  get 'people/edit'
# route  get 'people/new'
# route  get 'people/show'
# route  get 'people/index'
#invoke  erb
#create    app/views/people
#create    app/views/people/index.html.erb
#create    app/views/people/show.html.erb
#create    app/views/people/new.html.erb
#create    app/views/people/edit.html.erb
#create    app/views/people/create.html.erb
#create    app/views/people/update.html.erb
#create    app/views/people/destroy.html.erb
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
