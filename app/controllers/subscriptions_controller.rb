class SubscriptionsController < ApplicationController
  before_action :track_path_visit, :authenticate_user!, :set_portal_session 

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
        allow_promotion_codes: true,
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

  def free_trial
    if Rails.env.development?
      price = "price_1MNvKeBkWgBbsxE3uGOeoC8T"
    else
      price = "price_1MQGQZBkWgBbsxE3yq6UtyUJ"
    end

    name = "Facilitator - monthly"

    if current_user.subscriptions.any?
      redirect_to @portal_session.url, allow_other_host: true 
    else
      @checkout_session = current_user.payment_processor.checkout(
        mode: 'subscription',
        subscription_data: {
          items: [{
            plan: price
          }],
          trial_settings: { end_behavior: {missing_payment_method: "cancel"}},
          trial_period_days: 30,
        },
        payment_method_collection: "if_required",
        success_url: your_plan_url,
        cancel_url: root_url
      )
    
      # If you want to redirect directly to checkout
       redirect_to @checkout_session.url, allow_other_host: true, status: :see_other
    end
  end

  def lifetime_free_access
    if Rails.env.development?
      price = "price_1MNv1dBkWgBbsxE3L7bCqq8M"
      coupon_id = "PVi0eUPL"
    else
      price = "price_1MQGQZBkWgBbsxE3AKrVIAwX"
      coupon_id = "zWoFs854"
    end

    name = "Facilitator - yearly"

    if current_user.subscriptions.any?
      redirect_to @portal_session.url, allow_other_host: true 
    else
      @checkout_session = current_user.payment_processor.checkout(
        mode: 'subscription',
        discounts: [{
          coupon: coupon_id,
        }],
        subscription_data: {
          items: [{
            plan: price
          }],
          metadata: {
            "lifetime_free_access": true
          },
        },
        payment_method_collection: "if_required",
        success_url: your_plan_url,
        cancel_url: root_url
      )
    
      # If you want to redirect directly to checkout
       redirect_to @checkout_session.url, allow_other_host: true, status: :see_other
    end
  end

  def redeem_lifetime_free_access_coupon
    if Rails.env.development?
      price = "price_1MNv1dBkWgBbsxE3L7bCqq8M"
    else
      price = "price_1MQGQZBkWgBbsxE3AKrVIAwX"
    end

    name = "Facilitator - yearly"

    if current_user.subscriptions.any?
      redirect_to @portal_session.url, allow_other_host: true 
    else
      @checkout_session = current_user.payment_processor.checkout(
        mode: 'subscription',
        allow_promotion_codes: true,
        subscription_data: {
          items: [{
            plan: price
          }],
          metadata: {
            "redeem_lifetime_free_access_coupon": true
          },
        },
        payment_method_collection: "if_required",
        success_url: your_plan_url,
        cancel_url: root_url
      )
    
      # If you want to redirect directly to checkout
       redirect_to @checkout_session.url, allow_other_host: true, status: :see_other
    end
  end

  def your_plan
  end
end
