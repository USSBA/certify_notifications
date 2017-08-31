module CertifyNotifications
  # notification class that handles getting and send new notifications
  class ActivityLog < Resource
    # rubocop:disable Metrics/AbcSize
    def self.where(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = activity_log_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      return CertifyNotifications.unprocessable if safe_params[:application_id].nil?
      response = connection.request(method: :get,
                                    path: build_activity_log_path(safe_params))
      puts response
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyNotifications.service_unavailable error.class
    end

    private_class_method

    # returns the body as a parsed JSON hash, or as a simple hash if nil
    def self.parse_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # helper for white listing parameters
    def self.activity_log_safe_params(p)
      permitted_keys = %w[application_id page per_page]
      symbolize_params(p.select { |key, _| permitted_keys.include? key.to_s })
    end

    def self.build_activity_log_path(p)
      "#{path_prefix}/#{activity_log_path}?application_id=#{p[:application_id]}"
    end
  end
end
