defmodule CommandedDebugger.TestState do
  def get do
    [
      %CommandedDebugger.EventAudit{
        causation_id: "4178f1d0-b301-4d4a-bc48-fe6165684b6f",
        correlation_id: "4df6200d-4bbc-4cf5-bb34-79b2f192f48e",
        created_at: ~N[2019-06-06 13:09:26.897166],
        data:
          "{\"detected_amount\":\"0.0277\",\"source_uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\",\"uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\"}",
        metadata: %{
          causation_id: "4178f1d0-b301-4d4a-bc48-fe6165684b6f",
          correlation_id: "4df6200d-4bbc-4cf5-bb34-79b2f192f48e",
          created_at: ~N[2019-06-06 13:09:26.897166],
          event_id: "a0356c70-5959-4c34-9248-24f4f8fa8ac3",
          event_number: 15,
          stream_id: "payment-878ff9a5-832e-4da1-aa71-778dade60087",
          stream_version: 2
        },
        type: "Elixir.Events.PaymentDetected",
        uuid: "a0356c70-5959-4c34-9248-24f4f8fa8ac3"
      },
      %CommandedDebugger.CommandAudit{
        callback_data: %{execution_duration_usecs: 9209, success: true},
        causation_id: "5df08072-3a49-488c-be29-0c50e11e1812",
        correlation_id: "4df6200d-4bbc-4cf5-bb34-79b2f192f48e",
        data:
          "{\"detected_amount\":\"0.0277\",\"uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\"}",
        metadata: %{},
        occurred_at: ~N[2019-06-06 13:09:26.895484],
        type: "Elixir.Platform.Payments.Commands.DetectPayment",
        uuid: "4178f1d0-b301-4d4a-bc48-fe6165684b6f"
      },
      %CommandedDebugger.EventAudit{
        causation_id: "8bab8442-c4fd-49d1-a8b9-da8c9ec501d4",
        correlation_id: "4df6200d-4bbc-4cf5-bb34-79b2f192f48e",
        created_at: ~N[2019-06-06 13:09:26.862412],
        data:
          "{\"address\":\"0x1dEb706C925dA791Bf731C0fD7C718bAe45d200D\",\"amount\":\"0.0277\",\"assignee_id\":\"878ff9a5-832e-4da1-aa71-778dade60087\",\"blockchain\":\"ETH\",\"currency\":\"ETH\",\"tx_id\":\"ETH/0xdd756dd69d386761aca2c9171932fa7fea8d86b7393a5f7565e9b517c0649a5c/root\"}",
        metadata: %{
          causation_id: "8bab8442-c4fd-49d1-a8b9-da8c9ec501d4",
          correlation_id: "4df6200d-4bbc-4cf5-bb34-79b2f192f48e",
          created_at: ~N[2019-06-06 13:09:26.862412],
          event_id: "5df08072-3a49-488c-be29-0c50e11e1812",
          event_number: 14,
          stream_id: "address-ETH-0x1dEb706C925dA791Bf731C0fD7C718bAe45d200D",
          stream_version: 1
        },
        type: "Elixir.Events.TxDetected",
        uuid: "5df08072-3a49-488c-be29-0c50e11e1812"
      },
      %CommandedDebugger.EventAudit{
        causation_id: "25598fc1-23f3-43b0-8a34-753bed5f6c61",
        correlation_id: "c2804845-1806-44fb-97a7-dbab5ef35f9b",
        created_at: ~N[2019-06-06 13:01:54.080897],
        data:
          "{\"address\":\"0x1dEb706C925dA791Bf731C0fD7C718bAe45d200D\",\"amount\":\"0.02770\",\"exchange_rate\":{\"from\":\"EUR\",\"rate\":\"0.004623556963435816515141604391\",\"spread\":0,\"to\":\"ETH\"},\"expires_at\":\"2019-06-06T14:00:58Z\",\"receiver_uuid\":null,\"requested_amount\":\"5.99\",\"requested_currency\":\"EUR\",\"selected_currency\":\"ETH\",\"source_type\":\"order\",\"source_uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\",\"uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\"}",
        metadata: %{
          causation_id: "25598fc1-23f3-43b0-8a34-753bed5f6c61",
          correlation_id: "c2804845-1806-44fb-97a7-dbab5ef35f9b",
          created_at: ~N[2019-06-06 13:01:54.080897],
          event_id: "af3e7cd7-2e3f-464a-83ad-af09c08149c1",
          event_number: 13,
          stream_id: "payment-878ff9a5-832e-4da1-aa71-778dade60087",
          stream_version: 1
        },
        type: "Elixir.Events.PaymentRequested",
        uuid: "af3e7cd7-2e3f-464a-83ad-af09c08149c1"
      },
      %CommandedDebugger.CommandAudit{
        callback_data: %{execution_duration_usecs: 14015, success: true},
        causation_id: nil,
        correlation_id: "c2804845-1806-44fb-97a7-dbab5ef35f9b",
        data:
          "{\"address\":\"0x1dEb706C925dA791Bf731C0fD7C718bAe45d200D\",\"amount\":\"0.02770\",\"exchange_rate\":{\"from\":\"EUR\",\"rate\":\"0.004623556963435816515141604391\",\"spread\":0,\"to\":\"ETH\"},\"expires_at\":\"2019-06-06T14:00:58Z\",\"requested_amount\":\"5.99\",\"requested_currency\":\"EUR\",\"selected_currency\":\"ETH\",\"source_type\":\"order\",\"source_uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\",\"uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\"}",
        metadata: %{},
        occurred_at: ~N[2019-06-06 13:01:54.075029],
        type: "Elixir.Platform.Payments.Commands.RequestPayment",
        uuid: "25598fc1-23f3-43b0-8a34-753bed5f6c61"
      },
      %CommandedDebugger.EventAudit{
        causation_id: "3d94f75d-6dda-4e92-a13d-a25217f77ac3",
        correlation_id: "f715b521-2650-4f88-bc52-606260aa048a",
        created_at: ~N[2019-06-06 13:00:59.142119],
        data:
          "{\"buyer_address1\":\"118 Main St\",\"buyer_address2\":\"7th Floor\",\"buyer_city\":\"New York\",\"buyer_country\":\"US\",\"buyer_email\":\"john@example.com\",\"buyer_first_name\":\"John\",\"buyer_last_name\":\"Doe\",\"buyer_postcode\":\"10001\",\"buyer_state\":\"New York\",\"created_at\":\"2019-06-06T13:00:58.972443Z\",\"exchange_rates\":[{\"combinator\":\"product\",\"from\":\"EUR\",\"pairs\":[{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Bitstamp\",\"rate\":\"1.127625\",\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Coinbase\",\"rate\":\"1.13\",\"timestamp\":\"2019-06-06T13:00:57.256462Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Kucoin\",\"rate\":\"0.004093534744846212278386643961\",\"timestamp\":\"2019-06-06T13:00:58.961203Z\",\"to\":\"ETH\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Bitfinex\",\"rate\":\"0.004098360655737704918032786885\",\"timestamp\":\"2019-06-06T13:00:58.688869Z\",\"to\":\"ETH\"}],\"rate\":\"0.004623556963435816515141604391\",\"rate_before_spread\":\"0.004623556963435816515141604391\",\"spread\":0,\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"ETH\"},{\"combinator\":\"product\",\"from\":\"EUR\",\"pairs\":[{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Bitstamp\",\"rate\":\"1.127625\",\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Coinbase\",\"rate\":\"1.13\",\"timestamp\":\"2019-06-06T13:00:57.256462Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Hitbtc\",\"rate\":\"0.0001292493135245835425556596013\",\"timestamp\":\"2019-06-06T13:00:58.384637Z\",\"to\":\"BTC\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Kucoin\",\"rate\":\"0.0001288399125434673654943523024\",\"timestamp\":\"2019-06-06T13:00:58.335339Z\",\"to\":\"BTC\"}],\"rate\":\"0.0001456671722504708578216020311\",\"rate_before_spread\":\"0.0001456671722504708578216020311\",\"spread\":0,\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"BTC\"}],\"expires_at\":\"2019-08-05T13:00:58.972443Z\",\"line_items\":[{\"currency\":\"EUR\",\"name\":\"UTRUST Mug\",\"price\":\"4.17\",\"quantity\":1,\"sku\":\"FWRY832876\"},{\"currency\":\"EUR\",\"name\":\"Shipping - Flat rate\",\"price\":\"0.99\",\"quantity\":1,\"sku\":\"FWRY832877\"},{\"currency\":\"EUR\",\"name\":\"Tax - IVA23\",\"price\":\"0.83\",\"quantity\":1,\"sku\":\"FWRY832878\"}],\"merchant_uuid\":\"7e543e3e-a006-47f8-911b-0bd0ca6ae9ff\",\"order_currency\":\"EUR\",\"order_reference\":\"order-1\",\"order_total\":\"5.99\",\"order_urls\":{\"callback_url\":null,\"cancel_url\":\"http://example.com/cancel\",\"return_url\":\"http://example.com/return\"},\"pricing_details\":{\"shipping\":null,\"tax\":null},\"store_uuid\":\"e2c503a6-1ab9-48ad-8394-5ac8eaa761b6\",\"uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\"}",
        metadata: %{
          causation_id: "3d94f75d-6dda-4e92-a13d-a25217f77ac3",
          correlation_id: "f715b521-2650-4f88-bc52-606260aa048a",
          created_at: ~N[2019-06-06 13:00:59.142119],
          event_id: "ab0f508d-e4d6-4c12-90d5-a9c66e71a5a2",
          event_number: 12,
          stream_id: "order-878ff9a5-832e-4da1-aa71-778dade60087",
          stream_version: 1
        },
        type: "Elixir.Events.OrderPlaced",
        uuid: "ab0f508d-e4d6-4c12-90d5-a9c66e71a5a2"
      },
      %CommandedDebugger.CommandAudit{
        callback_data: %{execution_duration_usecs: 17544, success: true},
        causation_id: nil,
        correlation_id: "f715b521-2650-4f88-bc52-606260aa048a",
        data:
          "{\"buyer_address1\":\"118 Main St\",\"buyer_address2\":\"7th Floor\",\"buyer_city\":\"New York\",\"buyer_country\":\"US\",\"buyer_email\":\"john@example.com\",\"buyer_first_name\":\"John\",\"buyer_last_name\":\"Doe\",\"buyer_postcode\":\"10001\",\"buyer_state\":\"New York\",\"created_at\":\"2019-06-06T13:00:58.972443Z\",\"exchange_rates\":[{\"combinator\":\"product\",\"from\":\"EUR\",\"pairs\":[{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Bitstamp\",\"rate\":\"1.127625\",\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Coinbase\",\"rate\":\"1.13\",\"timestamp\":\"2019-06-06T13:00:57.256462Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Kucoin\",\"rate\":\"0.004093534744846212278386643961\",\"timestamp\":\"2019-06-06T13:00:58.961203Z\",\"to\":\"ETH\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Bitfinex\",\"rate\":\"0.004098360655737704918032786885\",\"timestamp\":\"2019-06-06T13:00:58.688869Z\",\"to\":\"ETH\"}],\"rate\":\"0.004623556963435816515141604391\",\"rate_before_spread\":\"0.004623556963435816515141604391\",\"spread\":0,\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"ETH\"},{\"combinator\":\"product\",\"from\":\"EUR\",\"pairs\":[{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Bitstamp\",\"rate\":\"1.127625\",\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"EUR\",\"provider\":\"Elixir.ExchangeRates.Apis.Coinbase\",\"rate\":\"1.13\",\"timestamp\":\"2019-06-06T13:00:57.256462Z\",\"to\":\"USD\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Hitbtc\",\"rate\":\"0.0001292493135245835425556596013\",\"timestamp\":\"2019-06-06T13:00:58.384637Z\",\"to\":\"BTC\"},{\"error\":null,\"from\":\"USD\",\"provider\":\"Elixir.ExchangeRates.Apis.Kucoin\",\"rate\":\"0.0001288399125434673654943523024\",\"timestamp\":\"2019-06-06T13:00:58.335339Z\",\"to\":\"BTC\"}],\"rate\":\"0.0001456671722504708578216020311\",\"rate_before_spread\":\"0.0001456671722504708578216020311\",\"spread\":0,\"timestamp\":\"2019-06-06T13:00:57.288178Z\",\"to\":\"BTC\"}],\"expires_at\":null,\"line_items\":[{\"currency\":\"EUR\",\"name\":\"UTRUST Mug\",\"price\":\"4.17\",\"quantity\":1,\"sku\":\"FWRY832876\"},{\"currency\":\"EUR\",\"name\":\"Shipping - Flat rate\",\"price\":\"0.99\",\"quantity\":1,\"sku\":\"FWRY832877\"},{\"currency\":\"EUR\",\"name\":\"Tax - IVA23\",\"price\":\"0.83\",\"quantity\":1,\"sku\":\"FWRY832878\"}],\"merchant_uuid\":\"7e543e3e-a006-47f8-911b-0bd0ca6ae9ff\",\"order_currency\":\"EUR\",\"order_reference\":\"order-1\",\"order_total\":\"5.99\",\"order_urls\":{\"callback_url\":null,\"cancel_url\":\"http://example.com/cancel\",\"return_url\":\"http://example.com/return\"},\"pricing_details\":{\"shipping\":null,\"tax\":null},\"store_uuid\":\"e2c503a6-1ab9-48ad-8394-5ac8eaa761b6\",\"uuid\":\"878ff9a5-832e-4da1-aa71-778dade60087\"}",
        metadata: %{},
        occurred_at: ~N[2019-06-06 13:00:59.135054],
        type: "Elixir.Platform.Orders.Commands.PlaceOrder",
        uuid: "3d94f75d-6dda-4e92-a13d-a25217f77ac3"
      }
    ]
  end
end
