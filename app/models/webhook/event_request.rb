module Webhook
	class EventRequest < ApplicationRecord
		
		# Associations
		belongs_to :webhook_endpoint, class_name: "Webhook::Endpoint", foreign_key: :webhook_endpoint_id

		# Enums
		enum :status, { inprogress: 'inprogress', #While it is in inprogess
						success: 'success', # On successfull request
						failed: 'failed', # Failed due to any reason
						disable: 'disable'} # Disable requests no longer executed by worker

		# Scopes
		scope :active, -> {where.not(status: 'disable')}

		def success!
			update!(status: 'success')
		end

		def failed!
			update(status: 'failed')
		end

		def self.disable_not_for_events!(events) # event can be string(event) or array of strings(event)
			active.where.not(event: Array(events)).disable_all
		end

		def self.disable_for_events!(events)
			active.where(event: Array(events)).disable_all
		end

		private

		def self.disable_all
			update_all(status: 'disable', response: {message: "Subscription is removed for this event"})
		end
	end
end
