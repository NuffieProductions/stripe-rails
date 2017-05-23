require 'stripe/event'
module Stripe
  module EventDispatch
    def dispatch_stripe_event(params)
      # To support Rails 5, converted action controller object to Hash by 'to_unsafe_h'
      retrieve_stripe_event(params.to_unsafe_h) do |evt|
        target = evt.data.object
        ::Stripe::Callbacks.run_callbacks(evt, target)
      end
    end

    def retrieve_stripe_event(params)
      id = params['id']
      if id == 'evt_00000000000000' #this is a webhook test
        yield Stripe::Event.construct_from(params)
      else
        yield Stripe::Event.retrieve(id)
      end
    end
  end
end
