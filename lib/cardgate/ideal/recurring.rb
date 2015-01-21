module Cardgate

  module Ideal

    class Recurring < Cardgate::Recurring

      attr_accessor :referenced_transaction_id, :description

      def provider
        'ideal'
      end

      def recurring_params
        {
          recurring: {
            referenced_transaction_id: @referenced_transaction_id,
            description: @description
          }
        }
      end

    end

  end

end
