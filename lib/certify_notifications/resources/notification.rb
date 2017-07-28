module CertifyNotifications
  # notification class that handles getting and send new notifications
  class Notification < Resource
    # get list of notifications for a person
    # rubocop:disable Metrics/AbcSize
    def self.find(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_notifications_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyNotifications.service_unavailable error.class
    end

    # trigger a notification
    def self.create(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_notifications_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyNotifications.service_unavailable error.class
    end

    # update notification status
    def self.update(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      response = connection.request(method: :put,
                                    path: build_update_notification_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(check_empty_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyNotifications.service_unavailable error.class
    end

    private_class_method

    def self.check_empty_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # helper for white listing parameters
    def self.notification_safe_params(params)
      permitted_keys = %w[recipient_id email event_type subtype priority read options body email_subject certify_link]
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
