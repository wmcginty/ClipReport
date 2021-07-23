module Fastlane
  module Actions
    module SharedValues
      APP_CLIP_SIZE_REPORT_PROCESSED = :APP_CLIP_SIZE_REPORT_PROCESSED
    end

    class AppClipSizeReportAction < Action

      def self.is_supported?(platform)
        true
      end

      def self.process_report(report_path, include_on_demand_resources, include_variant_descriptors)
        if File.exist?(report_path, )
          report_contents = ""
          for line in IO.readlines(report_path, chomp: true)

            # Find the title of the App Thinning Report
            if report_contents.empty? || line.empty?
              report_contents += "\n" + line

            # Find the variant name
            elsif line.start_with?("Variant:")
              report_contents += "\n" + line

            # Find the variant descriptors when needed
            elsif line.include?("variant descriptors") && include_variant_descriptors
              report_contents += "\n" + line

            # Find the size information, including ODRs when needed
            elsif line.include?("size")
              if include_on_demand_resources || !line.include?("On Demand")
                report_contents += "\n" + line
              end
            end

          end

          return report_contents

        else
          UI.user_error!("Failed to find a report at #{report_path}.")
        end
      end

      def self.run(params)
        report = self.process_report(params[:report_path], params[:include_on_demand_resources] || false, params[:include_variant_descriptors] || false)

        Actions.lane_context[SharedValues::APP_CLIP_SIZE_REPORT_PROCESSED] = report
        return report
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :report_path,
                                       type: String,
                                       optional: false,
                                       env_name: "FL_APP_CLIP_SIZE_REPORT__PATH",
                                       description: "The file path to the App Thinning Report generated by the build",
                                       verify_block: proc do |value|
                                          UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),

          FastlaneCore::ConfigItem.new(key: :include_on_demand_resources,
                                       is_string: false,
                                       optional: true,
                                       default_value: false,
                                       env_name: "FL_APP_CLIP_SIZE_REPORT_INCLUDE_ODR",
                                       description: "Dictates if the outputted report should include on demand resources"),

          FastlaneCore::ConfigItem.new(key: :include_variant_descriptors,
                                       is_string: false,
                                       optional: true,
                                       default_value: false,
                                       env_name: "FL_APP_CLIP_SIZE_REPORT_INCLUDE_DESCRIPTORS",
                                       description: "Dictates if the outputted report should include on variant descriptors")
        ]
      end

      def self.output
        [
          ['APP_CLIP_SIZE_REPORT_PROCESSED', 'This value will contain the processed report from the given path']
        ]
      end

      def self.return_value
          ['Returns the processed report from the given path']
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["@wmcginty"]
      end
    end
  end
end
