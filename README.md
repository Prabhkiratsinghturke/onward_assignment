# README

Basic Requirements:

* Ruby(v=3.0.4) 

* Redis server(v=5.0.7)


Steps to setup:

* Execute "bundle install" command in current project root directory

* Run "rails db:create && rails db:migrate"

* Start rails server using "rails s"

* Start sidekiq server using "bundle exec sidekiq"


Steps to get the desired results:


* Open browser and navigate to "http://localhost:3000"

* Click on "New webhook endpoint" to add its basic details like url, events, and extra params.
* Click on view btn to see all webhook events requests.

* Add Product from top nav-bar

* Create/Update/Delete product and you will receive webhook request for subscribed endpoints.
