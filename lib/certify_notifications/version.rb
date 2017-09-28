module CertifyNotifications
  module VERSION
    MAJOR = 1
    MINOR = 0
    PATCH = 2
    PRE_RELEASE = "".freeze # e.g., "-beta"

    STRING = ([MAJOR, MINOR, PATCH].join('.') + PRE_RELEASE).freeze
  end
end
