shared_context 'with a running app' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }
end

shared_context 'with a client app' do
  let(:client_app) { Fabricate(:client_application, access_granted: true) }
  let(:xapp_token) do
    ApplicationTrust.create_for_token_authentication(
      application: client_app, expires_in: 1.day.from_now)
  end
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

shared_context 'with a running app and a client accessing V1::Anonymous' do
  include_context 'with a running app'

  let(:client) do
    Hyperclient.new(Gris::Identity.base_url) do |client|
      client.connection(default: false) do |conn|
        conn.request :hal_json
        conn.response :json
        conn.use Faraday::Adapter::Rack, app
      end
      client.headers.update('Accept' => 'application/vnd.santa-v1-anonymous+json')
    end
  end
end

shared_context 'with a running app and an authorized client accessing V1::Anonymous' do
  include_context 'with a running app'
  include_context 'with a client app'

  let(:client) do
    Hyperclient.new(Gris::Identity.base_url) do |client|
      client.headers['X-XAPP-TOKEN'] = xapp_token
      client.connection(default: false) do |conn|
        conn.request :hal_json
        conn.response :json
        conn.use Faraday::Adapter::Rack, app
      end
      client.headers.update('Accept' => 'application/vnd.santa-v1-anonymous+json')
    end
  end
end
