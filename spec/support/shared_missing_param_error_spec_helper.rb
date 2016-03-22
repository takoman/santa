shared_examples 'missing param' do
  it 'returns a missing param error message' do
    expect(request._response.body).to eq(
      'error' => "#{param} is missing"
    )
  end

  it 'raises a 400 error' do
    expect(request._response.status).to eq 400
  end
end
