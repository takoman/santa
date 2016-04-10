module Grape
  module Extensions
    module RedirectExtension
      def redirect!(url, options = {})
        redirect url, options
        throw :error, message: { _links: { location: { href: url } } }, status: @status, headers: @header
      end

      Grape::Endpoint.send(:include, self)
    end
  end
end
