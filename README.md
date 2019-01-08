# BottledObservers

![](https://ruby-gem-downloads-badge.herokuapp.com/bottled_observers?type=total)

## The best thing to happen since bottled water

Wait, wasn't that [bottled_decorators?](https://github.com/John-Hayes-Reed/bottled_decorators),
or was it [bottled_services?](https://github.com/John-Hayes-Reed/bottled_services), 
I am starting to lose track. Anyway! bottled_observers are an easy-to-use solution, 
for the Observer / Subscribe-Publish pattern in ruby. all you need to worry about 
is adding your business logic, let bottled_observers handle the rest!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bottled_observers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bottled_observers

## Usage

bottled_observers has two main modules you need to be aware of; BottledObserver and BottledObservable.  

#### BottledObserver

This module should be included in your observer class, and that observer class 
should only contain a single public method: `#call`.  
eg:

```ruby
class SendPushNotification
  include BottledObserver # <-- just like this!
  
  def call
    # Some intense and awesome logic to notify the hell out of them users.
  end
end
```

That is all there is to it, your observer is now ready to rock'n'roll.

#### BottledObservable

This module is included in any class that should allow observers to subscribe to it.  
eg:

```ruby
class Product
  include BottledObservable # <-- and just like this!
  
  # The rest of the class....
end
```

And that is it, your whole bottled_observers subscribe/publish cycle is ready to go.

#### The Subscribe / Publish Cycle  

There are three main methods available in your arsenal that you need to be aware of:
* `#add_subscription`
* `#modified`
* `#publish`

These are available to your observable class instances, so if we wanted to subscribe
our `SendPushNotification` observer to an instance of our `Product` class, we could
do the following:

```ruby
@product = Product.find(1)                     # <-- instantiate Product from a record in the database. 
@product.add_subscription SendPushNotification # <-- add a subscription for the SendPushNotification class
```

We now have a `SendPushNotification` observer lying in wait for any publications from the `@product` instance.  
Then, when we want to notify the observer(s) of any changes to the instance, just 
set the state of the instance as *modified* using the `#modified` method, and publish
this change of state to its subscribers:

*Example case: sending push notifications after a successful save of the @product instance.*
```ruby
# The product is only in a modified state if the save is successful
@product.modified if @product.save
 
# If the @product's state is 'modified' the observers call method will be excecuted. 
# If the state is not modified, nothing will happen.
@product.publish
```

**Super simple!**

Another thing that needs to be noted is, after publishing, the instances *modified* 
state is reset, so to publish anything again, it must be set again.

```ruby
@product.modified
@product.publish # <-- push notifications sent.
@product.publish # <-- push notifications not sent.
```

```ruby
@product.modified
@product.publish # <-- push notifications sent.
@product.modified
@product.publish # <-- push notifications sent.
```

#### Extras

You can have as many observers subscribed to a single instance as you like:
```ruby
@product.add_subscription SendPushNotification
@product.add_subscription MailToMailingList
@product.add_subscription CreateRecentActivityRecord

@product.modified if @product.save
@product.publish
```

`#subscriptions` will return an array of current observer instances subscribed to the observable instance:
```ruby
@product.add_subscription SendPushNotification
@product.subscriptions #=> [#<SendPushNotification:0x00...>]
```

To remove observers of a particular class, use `#remove_subscription`:
```ruby
@product.add_subscription SendPushNotification
@product.subscriptions #=> [#<SendPushNotification:0x00...>]
@product.remove_subscription SendPushNotification
@product.subscriptions #=> []
```

Or use `#remove_subscriptions` *(notice the plural)* to, you guessed it, remove **all** observers:
```ruby
@product.add_subscription SendPushNotification
@product.add_subscription MailToMailingList
@product.add_subscription CreateRecentActivityRecord
@product.subscriptions #=> [#<SendPushNotification:0x00...>, ...]

@product.remove_subscriptions
@product.subscriptions #=> []
```

You can also check if your product is in a modified state by checking if it is `#publishable?`:
```ruby
@product.publishable? #=> false
@product.modified
@product.publishable? #=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/John-Hayes-Reed/bottled_observers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BottledObservers project’s codebases, issue trackers, chat rooms and mailing lists is expected to have a beer or two before and enjoy life. Oh yeah and apparently this too: [code of conduct](https://github.com/[USERNAME]/bottled_observers/blob/master/CODE_OF_CONDUCT.md).
