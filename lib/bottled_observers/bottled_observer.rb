# @abstract A module that turns a class into an Observer Object.
module BottledObserver
  # Initializes a new Observer and starts observing a subscription.
  #
  # @param subscription [*] The instance that the observer watches.
  # @param options [Hash] Any options an observer instance may need.
  #
  # @example
  #   LastUpdatedAtObserver.new(@model)
  #   #=> #<LastUpdatedAtObserver:0x00...>
  #
  # @return [void]
  def initialize(subscription, **options)
    raise BottledObserverErrors::SubscriptionRequired unless subscription
    raise BottledObserverErrors::SubscriptionObjectNotObservable unless
      subscription.singleton_class < BottledObservable

    method_source = options.delete(:method_source)
    @subscription = subscription
    @options = options

    subscribe unless method_source =~ /add_subscription/
  end

  private

  # Start observing the subscription by adding itself to the observers list.
  #
  # @return [void]
  def subscribe
    @subscription.add_subscription self.class
  end

  # Checks if the subscription state is modified or not.
  #
  # @return [void]
  def modified?
    @subscription.observable_state
  end
end
