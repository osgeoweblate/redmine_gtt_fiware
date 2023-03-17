module RedmineGttFiware
  module Patches

    module IssuesControllerPatch
      def self.apply
        IssuesController.prepend self unless IssuesController < self
      end

      # Helper method to convert the string value to a boolean
      def to_boolean(str)
        str.to_s.downcase == "true"
      end

      def show
        # Get the "normalized" query parameter or set it to the value from the plugin setting
        @normalized = if params.key?(:normalized)
          to_boolean(params[:normalized])
        else
          to_boolean(Setting.plugin_redmine_gtt_fiware['ngsi_ld_format'])
        end

        respond_to do |format|
          format.jsonld { render template: "ngsi_ld/issue" }
          format.any { super }
        end
      end

    end
  end
end
