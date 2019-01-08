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
  #   @model.add_subscription(LastUpdatedAtObserver)
  #
  # @return [void]
  def add_subscription(observer, **args)
    subscriptions << observer.new(self, args.merge({method_source: __method__}))
  end

  # Removes an observer from the instances subscriptions list.
  #
  # @param observer [BottledObserver] The observer class to remove.
  #
  # @example
  #   @model.remove_subscription(LastUpdatedAtObserver)
  #
  # @return [void]
  def remove_subscription(observer)
    subscriptions.delete_if { |ob| ob.class == observer }
  end

  # Removes all current subscriptions.
  #
  # @example
  #   @model.remove_subscriptions
  # @return [void]
  def remove_subscriptions
    subscriptions.map(&:class).each(&method(:remove_subscription))
  end

  # Calls the update method of all subscriptions and returns the modified state
  #   back to false.
  #
  # @return [void]
  def publish
    subscriptions.each(&:call) if publishable?
    modified false
  end

  # Changes the observable state of the instance.
  #
  # @param state [true, false] Defaults to true.
  # @param _opts [Hash]
  # @options opts [Symbol] :subscription
  #
  # @return [void]
  def modified(state = true, **_opts)
    raise TypeError unless state == true || state == false
    @observable_state = state
  end

  # Gives the instance's current observable state.
  #
  # @example
  #   @model.publishable? #=> false
  #   @model.modified
  #   @model.publishable? #=> true
  #
  # @return [true, false]
  def publishable?
    @observable_state ||= false
  end
end
