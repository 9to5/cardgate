require 'test_helper'

module CardgateTestCases

  class RecurringTestCases < Test::Unit::TestCase

    def stub_cardgate_connection(status, response)
      cardgate_connection do |stubs|
        stubs.post('/rest/v1/ideal/recurring/') { [status, {}, response] }
      end
    end

    def test_create_recurring

      cardgate_connection = stub_cardgate_connection(201, CardgateFixtures::PAYMENT_SUCCESSFUL)
      Cardgate::Gateway.stubs(:connection).returns(cardgate_connection)

      recurring = Cardgate::Recurring.new(
        site_id: 5112,
        amount: 10000,
        ref: 'testorder9',
        currency: 'EUR'
      )

      recurring.provider = 'ideal'
      recurring.initiate

    end

    def test_raise_if_provider_not_set
      Cardgate::Gateway.merchant = 'a'
      Cardgate::Gateway.api_key = 'b'

      recurring = Cardgate::Recurring.new()
      recurring.provider = nil

      assert_raises Cardgate::Exception do
        recurring.initiate
      end
    end

  end

end
