# frozen_string_literal: true

# name: supporthub-header
# about: Injects proper header for SupportHub implementations
# version: 1.0.0
# authors: Illya Klymov <xanf@jozian.com>
# url: https://github.com/jozian/discourse-supporthub-header
# required_version: 2.7.0

enabled_site_setting :supporthub_header_enabled

register_asset "stylesheets/custom-styles.scss"

require "net/http"

after_initialize do
  module ::RemoteHeader
    class << self
      def cached_header_html(guardian)
        Rails
          .cache
          .fetch("supporthub_header_html", expires_in: 1.minute) do
            fetch_header_html(guardian.request)
          end
      end

      def cached_links(guardian)
        Rails
          .cache
          .fetch("supporthub_sidebar_links", expires_in: 1.minute) do
            fetch_sidebar_links(guardian.request)
          end
      end

      private

      def fetch_header_html(request)
        fetch_remote_html(request, "header")
      end

      def fetch_sidebar_links(request)
        fetch_remote_html(request, "links")
      end

      def fetch_remote_html(request, type)
        uri = URI(build_url(request, type))
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          response.body
        else
          Rails.logger.error("Failed to fetch remote: #{response.code} - #{response.message}")
          ""
        end
      rescue StandardError => e
        Rails.logger.error("Error fetching remote: #{e.message}")
        ""
      end

      def get_host(request)
        override_url = SiteSetting.supporthub_header_override_url

        return override_url if override_url.present?
        host = request.host
        port = request.port
        protocol = request.ssl? ? "https" : "http"

        host = "#{protocol}://#{host}"
        host << ":#{port}" if port != 80 && port != 443
      end

      def build_url(request, type)
        "#{get_host(request)}/discourse/#{type}"
      end
    end
  end

  # Add the cached HTML to site serializer with correct request access
  add_to_serializer(:site, :supporthub_header_html) { RemoteHeader.cached_header_html(scope) }
  add_to_serializer(:site, :supporthub_sidebar_links) { RemoteHeader.cached_links(scope) }
end
