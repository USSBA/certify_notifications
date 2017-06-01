module CertifyNotifications
  # notification class that handles getting and send new notifications
  class Notification < Resource
    # get list of notifications for a person
    # rubocop:disable Metrics/AbcSize
    def self.find(params)
      safe_params = notification_safe_params params
      return return_response("Invalid parameters submitted", 400) if safe_params.empty? && !params_except_ac(params).empty?
      response = connection.request(method: :get,
                                    path: build_find_notifications_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    # trigger a notification
    def self.create(params)
      safe_params = notification_safe_params params
      return return_response("Invalid parameters submitted", 422) if safe_params.empty? || params_except_ac(params).empty?
      response = connection.request(method: :post,
                                    path: build_create_notifications_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    # update notification status
    def self.update(params)
      safe_params = notification_safe_params params
      return return_response("Invalid parameters submitted", 422) if safe_params.empty? && !params.empty?
      response = connection.request(method: :put,
                                    path: build_update_notification_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      body = response.data[:body].empty? ? { message: 'No Content' } : json(response.data[:body])
      return_response(body, response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    private_class_method

    # helper for white listing parameters
    def self.notification_safe_params(params)
      permitted_keys = %w[id body recipient_id read]
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    def self.build_find_notifications_path(params)
      "#{path_prefix}/#{notifications_path}?#{URI.encode_www_form(params)}"
    end

    def self.build_create_notifications_path
      "#{path_prefix}/#{notifications_path}"
    end

    def self.build_update_notification_path(params)
      "#{path_prefix}/#{notifications_path}/#{params[:id]}"
    end
  end
end
