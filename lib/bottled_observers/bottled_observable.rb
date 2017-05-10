# @abstract A module to make any instance observable by a BottledObserver.
module BottledObservable
  # Gives a list of the instances current subscriptions.
  #
  # @example
  #   @model_a.subscriptions
  #   #=> []
  #
  #   @model_b.subscriptions
  #   # => [#<LastUpdatedAtObserver:0x00...>]
  #
  # @return [Array]
  def subscriptions
    @subscriptions ||= []
  end

  # Adds an observer to the instances subscription list.
  #
  # @param observer [BottledObserver] The observer to be added to the list.
  # @param args [Hash] Additional Arguments to be passed to the observer.
  #
  # @example
  #   @model.subscribe_to(LastUpdatedAtObserver)
  #
  # @return [void]
  def add_subscription(observer, **args)
    subscriptions << observer.new(self, args)
  end

  # Removes an observer from the instances subscriptions list.
  #
  # @param observer [BottledObserver] The observer class to remove.
  #
  # @example
  #   @model.unsubscribe(LastUpdatedAtObserver)
  #
  # @return [void]
  def remove_subscription(observer)
    subscriptions.delete_if { |ob| ob.class == observer }
  end

  # Removes all current subscriptions.
  #
  # @return [void]
  def remove_subscriptions
    subscriptions.each(&method(:remove_subscription))
  end

  # Calls the update method of all subscriptions.
  #
  # @return [void]
  def publish
    subscriptions.each(&:call)
  end

  # Changes the observable state of the instance.
  #
  # @param state [true, false] Defaults to true.
  # @param _opts [Hash]
  # @options opts [Symbol] :subscription
  #
  # @return [void]
  def modified(state = true, **_opts)
    @observable_state = state
  end

  # Gives the instance's current observable state.
  #
  # @return [true, false]
  def observable_state
    @observable_state ||= false
  end
end
