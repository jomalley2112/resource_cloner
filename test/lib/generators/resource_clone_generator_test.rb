require 'test_helper'
require 'generators/resource_clone/resource_clone_generator'

#rake test TEST=test/lib/generators/resource_clone_generator_test.rb

class ResourceCloneGeneratorTest < Rails::Generators::TestCase
  tests ResourceCloneGenerator
  destination Rails.root.join('../tmp/generators')
  
  def setup 
  	@orig_model = "person"
  	@clone_model = "cloned_person"
  	@args = [@clone_model, @orig_model, "--test-mode=true"]
  	prepare_destination
  	copy_dummy_files
  end

  def teardown
    run_generator @args , {:behavior => :revoke}
  end

  test "Assert clone model file is generated correctly" do
  	assert_no_file "/app/models/#{@clone_model}.rb"
  	run_generator @args
  	assert_file "app/models/#{@clone_model}.rb" do |clone| 
  		assert_match "class #{@clone_model.classify} < ActiveRecord::Base", clone
  	end
  end

  test "Assert clone model migration is generated correctly" do
  	migr_files = Dir["#{destination_root}/db/migrate/*_create_#{@clone_model.pluralize}.rb"]
  	assert(migr_files.count == 0)
  	#assert table doesn't exist yet (we are running in test mode so migrations aren't run)
  	#assert_not(ActiveRecord::Base.connection.table_exists?(@clone_model.pluralize), "table shouldn't exist")

  	run_generator @args
  	
  	migr_files = Dir["#{destination_root}/db/migrate/*_create_#{@clone_model.pluralize}.rb"]
  	assert(migr_files.count > 0, "no migration file")
  	assert_file migr_files.first do |clone|
	  	assert_match "class Create#{@clone_model.classify.pluralize} < ActiveRecord::Migration",
	  	 clone
	  	assert_match "create_table :#{@clone_model.pluralize} do |t|", clone
	  end
	  #assert table was created (we are running in test mode so migrations aren't run)
	  #assert(ActiveRecord::Base.connection.table_exists?(@clone_model.pluralize), "table doesn't exist")
  end
	
	test "Assert clone controller file was generated correctly" do
  	assert_no_file "/app/controllers/#{@clone_model.pluralize}_controller.rb"
  	run_generator @args
  	assert_file "app/controllers/#{@clone_model.pluralize}_controller.rb" do |clone| 
  		assert_match "class #{@clone_model.classify.pluralize}Controller < ApplicationController", clone
  		assert_no_match %r(@#{@orig_model.pluralize} \=), clone
  		assert_no_match %r(\s#{@orig_model.classify}\s), clone
  		assert_no_match %r(@#{@orig_model} \=), clone
  		assert_no_match %r(def #{@orig_model}_params), clone
  		assert_match %r(@#{@clone_model.pluralize} \=), clone
  		assert_match %r(\s#{@clone_model.classify}\s), clone
  		assert_match %r(@#{@clone_model} \=), clone
  		assert_match %r(def #{@clone_model}_params), clone
  	end
  end

  test "Assert clone view files were generated correctly" do
  	assert_no_directory "app/views/#{@clone_model.pluralize}"
  	
  	run_generator @args
  	
  	assert_file "app/views/#{@clone_model.pluralize}/index.html.haml" do |clone|
  		assert_no_match %r(@#{@orig_model.pluralize}\.), clone
  		assert_no_match %r(\s#{@orig_model.pluralize.humanize}\s), clone
  		assert_no_match %Q(link_to "Edit", edit_person_path(person)), clone
  		assert_no_match %Q(link_to "Del", person), clone
  		assert_no_match %Q(link_to 'New Person', new_person_path), clone
  		
  		assert_match %r(@#{@clone_model.pluralize}\.), clone
  		assert_match %r(\s#{@clone_model.pluralize.humanize}\s), clone
  		assert_match %Q(link_to "Edit", edit_cloned_person_path(cloned_person)), clone
  		assert_match %Q(link_to "Del", cloned_person), clone
  		assert_match %Q(link_to 'New Person', new_cloned_person_path), clone
  	end
  	assert_file "app/views/#{@clone_model.pluralize}/_form.html.haml" do |clone|
  		assert_no_match %r(@#{@orig_model}\s), clone
  		#Links
  		assert_match %r(@#{@clone_model}\s), clone
  	end
  	assert_file "app/views/#{@clone_model.pluralize}/edit.html.haml" do |clone|
  		assert_no_match %r(\s#{@orig_model.humanize}\s), clone
  		assert_match %r(\s#{@clone_model.humanize}\s), clone
  	end
  	assert_file "app/views/#{@clone_model.pluralize}/new.html.haml" do |clone|
  		assert_no_match %r(\s#{@orig_model.humanize}\s), clone
  		assert_match %r(\s#{@clone_model.humanize}\s), clone
  	end
  end

  test "assert routes were generated correctly" do
  	new_routes_block = %Q`get '/cloned_people/index'
  get '/cloned_people/new' => 'cloned_people#new'
  get '/cloned_people/:id' => 'cloned_people#show'
  get '/cloned_people/:id/edit' => 'cloned_people#edit'
  post 'cloned_people/' => 'cloned_people#create'
  put 'cloned_people/:id' => 'cloned_people#update'
  delete 'cloned_people/(:id)' => 'cloned_people#destroy'`

  	assert_file "config/routes.rb" do |routes|
  		assert_no_match "resources :#{@clone_model.pluralize}", routes
  		assert_no_match new_routes_block, routes
  	end
  	
  	run_generator @args
  	
  	assert_file "config/routes.rb" do |routes|
  		assert_match "resources :#{@clone_model.pluralize}", routes
  		assert_match new_routes_block, routes
  	end
  	
  end

  private
  	def copy_dummy_files
  		dummy_file_dir = File.expand_path("../dummy_test_files", __FILE__)
		  FileUtils.cp_r("#{dummy_file_dir}/config", "#{destination_root}/config")
		end

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
