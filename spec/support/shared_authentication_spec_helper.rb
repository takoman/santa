shared_examples_for 'an endpoint with xapp_token_authentication!' do |route_arrays|
  route_arrays.each do |route_array|
    it "returns 401 for #{route_array[0].upcase} #{route_array[1]}" do
      header route_array[2], route_array[3]
      send route_array[0], route_array[1]
      expect(response_code).to eq 401
    end
  end
end
