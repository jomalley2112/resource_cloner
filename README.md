### Resource Cloner ###

#### Description ####
This generator allows you to quickly clone one of your project's existing resources giving it a new name of your choosing. I found myself in need of something like this while working on (SqlSearchNSort)[https://github.com/jomalley2112/sql_search_n_sort]. While I wanted to reuse the specs I had already written (for test/dummy) to test all the different configuration combinations I found that for each different combo I was forced to create an entirely new model/controller/route-set/set of views for each one. Something like this didn't seem to exist out there. By its very nature it isn't all that DRY because it duplicates existing code and basically renames eveything, but it may come in helpful for configuration testing for your future plugins/gems.

#### Usage ####
- add `gem 'resource_clone'` to your Gemfile
- run `rails g resource_clone clone_model_name existing_model_name`


##### Routes #####



##### TODO #####
- Routes
	- Not cloning resources that are defined as blocks (nesting other resources)
	- Not cloning lines that refer to the resource as singular
	- Definitely missing other formats of drawing routes
- Tests and Specs
	- currently it does Not clone these
- Assets
	- currently it does Not clone these
- Helpers
	- currently it does Not clone these