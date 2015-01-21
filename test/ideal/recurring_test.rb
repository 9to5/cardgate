require 'test_helper'

module CardgateTestCases

  class IdealRecurringTestCases < Test::Unit::TestCase

    def stub_cardgate_connection(status, response)
      cardgate_connection do |stubs|
        stubs.post('/rest/v1/ideal/recurring/') { [status, {}, response] }
      end
    end

    def new_recurring_attributes_hash
      {
        site_id: 1,
        ref: 'transaction-reference',
        amount: 100,
        currency: 'EUR',
        description: 'test',
        referenced_transaction_id: 'transaction_id'
      }
    end

    def test_successful_recurring
      cardgate_connection = stub_cardgate_connection(201, CardgateFixtures::RECURRING_SUCCESSFUL)

      Cardgate::Gateway.stubs(:connection).returns(cardgate_connection)

      recurring_attributes = new_recurring_attributes_hash

      recurring = Cardgate::Ideal::Recurring.new(recurring_attributes)
      recurring.initiate

      assert_equal 123457, recurring.transaction_id
    end

    def test_unsuccessful_recurring
      cardgate_connection = stub_cardgate_connection(500, CardgateFixtures::RECURRING_UNSUCCESSFUL)

      Cardgate::Gateway.stubs(:connection).returns(cardgate_connection)

      recurring_attributes = new_recurring_attributes_hash

      recurring = Cardgate::Ideal::Recurring.new(recurring_attributes)

      assert_raises Cardgate::Exception do
        recurring.initiate
      end
    end

    def test_params
      recurring_attributes = new_recurring_attributes_hash

      recurring = Cardgate::Ideal::Recurring.new(recurring_attributes)
      params = recurring.params

      assert_equal 1, params[:recurring][:site_id]
      assert_equal 'transaction-reference', params[:recurring][:ref]
      assert_equal 100, params[:recurring][:amount]
      assert_equal 'EUR', params[:recurring][:currency]
      assert_equal 'test', params[:recurring][:description]
      assert_equal 'transaction_id', params[:recurring][:referenced_transaction_id]
    end

    def test_empty_customer_params
      recurring_attributes = new_recurring_attributes_hash

      recurring = Cardgate::Ideal::Recurring.new(recurring_attributes)
      params = recurring.params

      assert_nil params[:recurring][:customer]
    end

  end

end
