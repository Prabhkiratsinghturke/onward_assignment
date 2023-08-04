class Product < ApplicationRecord
	include Webhook::Observable
end
