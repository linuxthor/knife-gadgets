class Chef
  class CookbookUploader

      alias_method :real_validate_cookbooks, :validate_cookbooks

      def hook_fail (script)
        puts "*** hook script #{script} returned a non-zero exit - stopping ***"
        exit(2) 
      end

      def validate_cookbooks

        preval   = Chef::Config[:prevalidate_hook]
        postval  = Chef::Config[:postvalidate_hook]
        bookpath = Chef::Config[:cookbook_path]
        nodename = Chef::Config[:node_name]

	# Hook script before syntax check
        if preval
          cookbooks.each do |cb|
            hook_fail(preval) unless system({"CURRENT_COOKBOOK" => "#{cb.name}",
                                             "COOKBOOK_PATH" => "#{bookpath}",
                                             "NODE_NAME" => "#{nodename}"}, preval)
          end
        end

	# Original validate_cookbooks called here
        real_validate_cookbooks

        # Hook script after syntax check passes (just before actual upload)
        if postval
          cookbooks.each do |cb|
            hook_fail(postval) unless system({"CURRENT_COOKBOOK" => "#{cb.name}",
                                              "COOKBOOK_PATH" => "#{bookpath}",
                                              "NODE_NAME" => "#{nodename}"}, postval)
          end
        end

      end
  end
end
