### Resource Cloner ###

[![Gem Version](https://badge.fury.io/rb/resource_cloner.svg)](http://badge.fury.io/rb/resource_cloner)

#### Description ####
This generator allows you to quickly clone one of your project's existing resources giving it a new name of your choosing. I found myself in need of something like this while working on [SqlSearchNSort](https://github.com/jomalley2112/sql_search_n_sort). While I wanted to reuse the specs I had already written (for test/dummy) to test all the different configuration combinations I found that for each different combo I was forced to create an entirely new model/controller/route-set/set of views for each one. Something like this didn't seem to exist out there. By its very nature it isn't all that DRY because it duplicates existing code and basically renames eveything, but it may come in helpful for configuration testing for your future plugins/gems.

#### Usage ####
- add `gem 'resource_clone'` to your Gemfile
- run `rails g resource_clone person_clone person [--test-mode=true]`

##### Arguments #####
| Argument | Description                            | Optional? | Default |
| -------  | -------------------------------------- | --------- | ------- |
| #1       | singular name of resource to create    | No        | N/A     |
| #2       | singular name of resource to be cloned | No        | N/A     |

##### Options #####
| Option       | Description                                                           | Default |
| ------------ | --------------------------------------------------------------------- | ------- |
| --test-mode  | When set to true newly generated migrations are not automatically run | false   |


#### Resources generated/added ####

##### Model #####
- Generates `app/models/person_clone.rb`

##### Migration #####
- Generates a new migration file named `"#{timestamp}_create_person_clones.rb"`
- Runs migration if user chooses\*. 

\* _Note: If you choose to revoke (destroy) the action later you will need to manually rollback the migration._

##### Controller #####
- Generates `app/controllers/person_clones_controller.rb`

##### Routes #####
- Adds new lines to `config/routes.rb`

##### Views #####
- Generates any views that person has in `app/views/person_clones`

#### Testing ####
- run `rake test`

#### Possible Enhancements ####
- Routes
	- Not cloning resources that are defined as blocks (nesting other resources)
	- Not cloning lines that refer to the resource as singular
	- Definitely missing other formats of drawing routes
- Migration
	- Automatic rollback on destroy
- Currently it does Not clone the following:
	- Tests and Specs
	- Assets
	- Helpers
