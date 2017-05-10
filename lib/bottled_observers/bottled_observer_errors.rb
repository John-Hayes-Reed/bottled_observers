module BottledObserverErrors
  class SubscriptionRequired < StandardError; end
  class SubscriptionObjectNotObservable < StandardError; end
end