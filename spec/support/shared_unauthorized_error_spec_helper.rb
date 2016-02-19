shared_examples 'unauthorized' do
  it 'returns a unauthorized error message' do
    expect(request._response.body).to eq(
      'status' => 401, 'message' => 'Unauthorized.'
    )
  end

  it 'raises a 401 error' do
    expect(request._response.status).to eq 401
  end
end
