
module Fastlane
  module Actions

    class BuildClipAction < Action

      def self.is_supported?(platform)
        true
      end

      def self.run(params)
        output_directory = Pathname.new(params[:report_output_path]).parent.to_s

        other_action.gym(
             scheme: params[:scheme], configuration: params[:configuration], output_name: "Clip", clean: true, output_directory: output_directory,
             archive_path: File.join(output_directory, "Clip"), derived_data_path: "./dd",
             export_options: {
               include_bitcode: true,
               thinning: "<thin-for-all-variants>",
               method: params[:export_method],
               distributionBundleIdentifier: params[:clip_bundle_id]
             }
        )

        FileUtils.cp("#{output_directory}/App Thinning Size Report.txt", params[:report_output_path])
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
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       env_name: "FL_BUILD_CLIP_SCHEME", # The name of the environment variable
                                       description: "The scheme to build", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No scheme for BuildClipAction given, pass using `scheme: 'scheme'`") unless (value and not value.empty?)
                                       end),

          FastlaneCore::ConfigItem.new(key: :configuration,
                                       env_name: "FL_BUILD_CLIP_CONFIG",
                                       description: "The configuration to build the App Clip in",
                                       verify_block: proc do |value|
                                          UI.user_error!("No configuration for BuildClipAction given, pass using `configuration: 'configuration'`") unless (value and not value.empty?)
                                       end),

          FastlaneCore::ConfigItem.new(key: :export_method,
                                       env_name: "FL_BUILD_CLIP_EXPORT_METHOD",
                                       description: "The export method of the App Clip archive",
                                       verify_block: proc do |value|
                                         UI.user_error!("No export method for BuildClipAction given, pass using `export_method: 'method'`") unless (value and not value.empty?)
                                       end),

          FastlaneCore::ConfigItem.new(key: :report_output_path,
                                       env_name: "FL_BUILD_CLIP_OUTPUT_PATH",
                                       description: "The path at which the raw thinning report should be output to",
                                       verify_block: proc do |value|
                                          UI.user_error!("No output path for BuildClipAction given, pass using `report_output_path: 'path'`") unless (value and not value.empty?)
                                       end),

          FastlaneCore::ConfigItem.new(key: :clip_bundle_id,
                                       env_name: "FL_BUILD_CLIP_BUNDLE_ID",
                                       description: "The bundle identifier of the App Clip",
                                       verify_block: proc do |value|
                                          UI.user_error!("No bundle ID for BuildClipAction given, pass using `clip_bundle_id: 'id'`") unless (value and not value.empty?)
                                       end)
        ]
      end

      def self.authors
        ["@wmginty"]
      end
    end
  end
end
