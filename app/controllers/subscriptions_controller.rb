class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portal_session

  def checkout
    # Make sure the user's payment processor is Stripe
    current_user.set_payment_processor :stripe

    case
      when params[:plan] === "monthly"
        if Rails.env.development?
          price = "price_1MNvKeBkWgBbsxE3uGOeoC8T"
        else
          price = "price_1MQGQZBkWgBbsxE3yq6UtyUJ"
        end
        name = "Facilitator - monthly"
      when params[:plan]=== "yearly"
        if Rails.env.development?
          price = "price_1MNv1dBkWgBbsxE3L7bCqq8M"
        else
          price = "price_1MQGQZBkWgBbsxE3AKrVIAwX"
        end
        name = "Facilitator - yearly"
    end

    if current_user.subscriptions.any?
      redirect_to @portal_session.url, allow_other_host: true 
    else
      @checkout_session = current_user.payment_processor.checkout(
        mode: 'subscription',
        # line_items: [{
        #   price: price,
        #   quantity: 1
        # }],
        subscription_data: {
          items: [{
            plan: price
          }]
        },
        success_url: your_plan_url,
        cancel_url: root_url
      )
    
      # If you want to redirect directly to checkout
       redirect_to @checkout_session.url, allow_other_host: true, status: :see_other
    end
    # Or Subscriptions (https://stripe.com/docs/billing/subscriptions/build-subscription)

  end

  def your_plan
  end
end
