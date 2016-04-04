shared_examples_for 'an endpoint with xapp_token_authenticate!' do |routes|
  routes.each do |route|
    context "#{route[0].upcase} #{route[1]}" do
      let(:headers) { { 'Accept' => 'application/vnd.santa-v1-anonymous+json' } }
      before do
        headers.each_pair { |k, v| header k, v }
        send route[0], route[1]
      end

      it 'returns 401' do
        expect(response_code).to eq 401
      end
      it 'returns "application token is required" error message' do
        expect(response_body).to eq({
          status: 401,
          message: 'An application token is required.'
        }.to_json)
      end
    end
  end
end

shared_examples_for 'an endpoint with user_authenticate!' do |routes|
  routes.each do |route|
    context "#{route[0].upcase} #{route[1]}" do
      before do
        headers.each_pair { |k, v| header k, v }
        send route[0], route[1]
      end
      context 'without access token in the headers' do
        let(:headers) { { 'Accept' => 'application/vnd.santa-v1-authorized+json' } }
        it 'returns 401' do
          expect(response_code).to eq 401
        end
        it 'returns "user is required" error message' do
          expect(response_body).to eq({
            status: 401,
            message: 'A user is required.'
          }.to_json)
        end
      end
      context 'with invalid access token in the headers' do
        let(:headers) do
          {
            'Accept' => 'application/vnd.santa-v1-authorized+json',
            'X-ACCESS-TOKEN' => 'this-is-an-invalid-access-token'
          }
        end
        it 'returns 401' do
          expect(response_code).to eq 401
        end
        it 'returns "access token is invalid" error message' do
          expect(response_body).to eq({
            status: 401,
            message: 'The access token is invalid or has expired.'
          }.to_json)
        end
      end
    end
  end
end
