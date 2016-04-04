require 'spec_helper'

describe 'Ensure SSL' do
  include Rack::Test::Methods
  context 'with a running app and a client' do
    include_context 'with a running app'
    let(:client) do
      Hyperclient.new(Gris::Identity.base_url) do |client|
        client.connection(default: false) do |conn|
          conn.request :hal_json
          conn.response :json
          conn.use Faraday::Adapter::Rack, app
        end
      end
    end

    context 'production' do
      before do
        # https://github.com/tobmatth/rack-ssl-enforcer/blob/6c01471d8dd256590bb1100150e9004d71759904/test/rack-ssl-enforcer_test.rb#L867
        # https://github.com/tobmatth/rack-ssl-enforcer/blob/66b52915833d60c6ce6808eb4aa203dbb5cee356/lib/rack/ssl-enforcer/constraint.rb#L37
        @original_env = ENV['RACK_ENV']
        ENV['RACK_ENV'] = 'production'
      end

      after { ENV['RACK_ENV'] = @original_env }

      it 'forces SSL' do
        response = client._get._response
        expect(response.status).to eq 301
        expect(response.headers['Location']).to eq 'https://localhost/'
        expect(response.body).to be_nil
      end
    end

    %w(development test).each do |env|
      context env.to_s do
        it 'does not force SSL' do
          response = client._get._response
          expect(response.status).to eq 200
          expect(response.headers).to_not include 'Location'
        end
      end
    end
  end
end
