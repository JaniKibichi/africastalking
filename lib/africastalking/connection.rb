module Africastalking
	class Connection
		include HTTParty

		headers
		format :json
		base_uri "https://orta.xyz/api/"      if Rails.env.production?
		base_uri "http://127.0.0.1:9292/api/" if Rails.env.development?

		class << self

			def headers
				OrtaApi.configuration.header.merge!(super)
			end

			%w(get put post delete).each do |method|
				define_method method do |path, options={}, &block|
					json_body = {body: options.to_json}

					response  = perform_request Net::HTTP::Put,    path, json_body, &block if method.eql?('put')
					response  = perform_request Net::HTTP::Post,   path, json_body, &block if method.eql?('post')
					response  = perform_request Net::HTTP::Get,    path, json_body, &block if method.eql?('get')
					response  = perform_request Net::HTTP::Delete, path, json_body, &block if method.eql?('delete')

					OrtaApi::Response.new(code: response.code, headers: response.headers, body: response.body)
				end
			end
		end
	end
end
