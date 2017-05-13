require 'spec_helper'

RSpec.describe BottledObservers do
  it 'has a version number' do
    expect(BottledObservers::VERSION).not_to be nil
  end

  context 'BottledObserver#initialize' do
    subject do
      # The Observer class.
      class TheObserver
        include BottledObserver
      end
    end

    context 'with no subscription' do
      it do
        expect { subject.new nil }
          .to raise_error BottledObserverErrors::SubscriptionRequired
      end
    end
    context 'with non observable subscription' do
      let(:non_observable) do
        class NoObserve; end
        NoObserve.new
      end
      it do
        expect { subject.new non_observable }
          .to raise_error BottledObserverErrors::SubscriptionObjectNotObservable
      end
    end

    context 'with observable subscription' do
      let(:observable) do
        # Observable class
        class CanObserve
          include BottledObservable
        end
        CanObserve.new
      end
      it do
        expect(subject.new(observable))
          .to be_a_kind_of BottledObserver
      end
    end
  end

  context 'BottledObservable' do
    let!(:observer) do
      # The Observer class.
      class TheObserver
        include BottledObserver

        def call
          @subscription.alert = 'I have successfully published'
        end
      end
      TheObserver
    end

    let!(:second_observer) do
      # A second Observer class.
      class TheSecondObserver
        include BottledObserver

        def call
          @subscription.first_att = 3
        end
      end
      TheSecondObserver
    end

    let(:observable) do
      # The class to be observed.
      class ObservableClass
        include BottledObservable
        attr_accessor :first_att, :second_att, :alert

        def initialize
          @first_att = 1
          @second_att = 2
          @alert = ''
        end
      end
      ObservableClass.new
    end

    context '#subscriptions' do
      subject { observable.subscriptions }
      it { is_expected.to be_a Array }
      it { is_expected.to be_empty }
    end

    context '#add_subscription' do
      subject { observable.add_subscription observer }
      it { is_expected.to be_a Array }
      it { is_expected.to include observer }
    end

    context '#remove_subscription' do
      before { observable.add_subscription observer }
      subject { observable.remove_subscription observer }
      it 'should not have any observers subscribed to it' do
        subject
        expect(observable.subscriptions).to be_empty
      end
    end

    context '#remove_subscriptions' do
      before { observable.add_subscription observer }
      before { observable.add_subscription second_observer }
      subject { observable.remove_subscriptions }
      it 'should not have any observers subscribed to it' do
        subject
        expect(observable.subscriptions).to be_empty
      end
    end

    context '#publish' do
      context 'with a single observer' do
        before { observable.add_subscription observer }
        context 'when not publishable?' do
          subject { observable.publish }
          it 'should not have the modifications made by the observer' do
            subject
            expect(observable.alert).to be_empty
          end
        end

        context 'when publishable?' do
          before { observable.modified }
          subject { observable.publish }
          it 'should have the modifications made by the observer' do
            subject
            expect(observable.alert).not_to be_empty
            expect(observable.publishable?).to be_falsey
          end
        end
      end

      context 'with multiple observers' do
        before { observable.add_subscription observer }
        before { observable.add_subscription second_observer }
        context 'when not publishable?' do
          subject { observable.publish }
          it 'should not have the modifications made by the observer' do
            subject
            expect(observable.alert).to be_empty
            expect(observable.first_att).to eq 1
          end
        end

        context 'when publishable?' do
          before { observable.modified }
          subject { observable.publish }
          it 'should have the modifications made by the observer' do
            subject
            expect(observable.alert).not_to be_empty
            expect(observable.first_att).to eq 3
            expect(observable.publishable?).to be_falsey
          end
        end
      end
    end

    context '#modified' do
      context 'to default' do
        subject { observable.modified }
        it { is_expected.to be_truthy }
      end

      context 'passing true' do
        subject { observable.modified true }
        it { is_expected.to be_truthy }
      end

      context 'passing false' do
        subject { observable.modified false }
        it { is_expected.to be_falsey }
      end

      context 'passing non boolean value' do
        subject { -> { observable.modified 1 } }
        it { is_expected.to raise_error TypeError }
      end
    end

    context '#publishable?' do
      context 'without calling modified' do
        subject { observable.publishable? }
        it { is_expected.to be_falsey }
      end

      context 'after calling modified' do
        before { observable.modified }
        subject { observable.publishable? }
        it { is_expected.to be_truthy }
      end
    end
  end
end
