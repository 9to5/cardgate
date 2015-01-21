module Cardgate

  module Ideal

    class Payment < Cardgate::Payment

      attr_accessor :issuer_id, :recurring

      def provider
        'ideal'
      end

      def payment_params
        {
          payment: {
            issuer_id: @issuer_id,
            recurring: @recurring
          }
        }
      end

    end

  end

end
