require 'test_helper'
require 'generators/resource_clone/resource_clone_generator'

#rake test TEST=test/lib/generators/resource_clone_generator_test.rb

class ResourceCloneGeneratorTest < Rails::Generators::TestCase
  tests ResourceCloneGenerator
  destination Rails.root.join('../tmp/generators')
  
  def setup 
  	@orig_model = "person"
  	@clone_model = "cloned_person"
  	@args = [@clone_model, @orig_model]
  	prepare_destination
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
  		assert_no_match %r(link_to .*#{@orig_model.humanize}.*, new_#{@orig_model}_path), clone
  		
  		assert_match %r(@#{@clone_model.pluralize}\.), clone
  		assert_match %r(\s#{@clone_model.pluralize.humanize}\s), clone
  		assert_match %r(link_to .*, #{@clone_model}), clone
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

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
