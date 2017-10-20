module CertifyNotifications
  # notification class that handles getting and send new notifications
  class Notification < Resource
    SOFT_VALIDATION = false
    STRICT_VALIDATION = true

    # get list of notifications for a person
    # rubocop:disable Metrics/AbcSize
    def self.where(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_notifications_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end
    singleton_class.send(:alias_method, :find, :where)

    def self.create(params = nil)
      create_soft(params)
    end

    # trigger a set of notifications with soft validation
    def self.create_soft(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_create_safe_param(SOFT_VALIDATION, params)
      notification_create_request safe_params
    end

    #trigger a set of notfication with strict validation
    def self.create_strict(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_create_safe_param(STRICT_VALIDATION, params)
      notification_create_request safe_params
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
      return_response(parse_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    private_class_method

    # returns the body as a parsed JSON hash, or as a simple hash if nil
    def self.parse_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # helper for white listing parameters
    def self.notification_safe_params(p)
      permitted_keys = %w[id recipient_id application_id email event_type subtype priority read options body email_subject certify_link page per_page]
      symbolize_params(p.select { |key, _| permitted_keys.include? key.to_s })
    end

    def self.notification_create_safe_param(strict, p)
      safe_params = {strict: strict}
      safe_params[:notifications] = []
      [p].flatten(1).each do |notification_params|
        safe_params[:notifications].push(notification_safe_params(notification_params)) unless notification_safe_params(notification_params).empty?
      end
      safe_params
    end

    def self.notification_create_request(safe_params)
      return CertifyNotifications.unprocessable if safe_params[:notifications].empty?
      response = connection.request(method: :post,
                                    path: build_create_notifications_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(parse_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
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
