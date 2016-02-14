class ApplicationEndpoint < Grape::API
  mount V1::Public::Endpoints::RootEndpoint
  # mount V1::Anonymous::Endpoints::RootEndpoint
  # mount V1::Authorized::Endpoints::RootEndpoint
  # mount V1::Admin::Endpoints::RootEndpoint
end
