shared_context 'with a running app' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }
end

shared_context 'with a running app and a client accessing V1::Public' do
  include_context 'with a running app'

  let(:client) do
    Hyperclient.new(Gris::Identity.base_url) do |client|
      client.connection(default: false) do |conn|
        conn.request :hal_json
        conn.response :json
        conn.use Faraday::Adapter::Rack, app
      end
      client.headers.update('Accept' => 'application/vnd.santa-v1-public+json')
    end
  end
end
