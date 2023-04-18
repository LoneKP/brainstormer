Pay.setup do |config|
  config.support_email = "Brainstormer <brainstormer.online@gmail.com>"
  config.application_name = "Brainstormer"
  config.business_name = "Brainstormer"


  config.emails.subscription_renewing = ->(pay_subscription, price) {
    (price&.type == "recurring") && (price.recurring&.interval == "year")
  }

  config.emails.subscription_renewing = ->(pay_subscription, price) {
    (price&.type == "recurring") && (price.recurring&.interval == "month")
  }

end