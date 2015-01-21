module Cardgate

  class Recurring

    attr_accessor :provider, :site_id, :ref, :amount, :currency

    def initialize(attributes = {})
      attributes.each do |k,v|
        send("#{k}=", v)
      end
    end

    def default_params
      {
        recurring: {
          site_id: @site_id,
          currency: @currency,
          ref: @ref,
          amount: @amount
        }
      }
    end

    def initiate
      @response ||= response

      self
    end

    def transaction_id
      @response.body['recurring']['transaction_id']
    end

    def params
      default_params.deep_merge!(recurring_params)
    end

    def recurring_params
      {}
    end

    def api_recurring_endpoint
      "/rest/v1/#{provider}/recurring/"
    end

    def provider
      @provider or raise Cardgate::Exception.new('Provider not set for Payment')
    end

    private

    def response
      result = Cardgate::Gateway.connection.post do |req|
        req.url api_recurring_endpoint
        req.headers['Accept'] = 'application/json'
        req.body = params
      end

      Cardgate::Response.new(result)
    end

  end

end
