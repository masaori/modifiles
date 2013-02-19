require 'pathname'

module Modifiles

  class Checker

    class << self
      attr_accessor :stamp_file_path

      def stamp
        File.open(@stamp_file_path, "w") { |io| io.write `git log -1 --pretty=format:%H` }
      end

      def last_stamp
        if File.exists? @stamp_file_path
          File.open(@stamp_file_path) { |io| io.read }
        else
          `git log --pretty=format:%H | tail -1`
        end
      end

      def diff_list(filter=nil)
        if filter
          `git diff --name-only --diff-filter=#{filter} #{last_stamp} HEAD`.split("\n").map {|e| File.join(GIT_ROOT, e)}
        else
          `git diff --name-only #{last_stamp} HEAD`.split("\n").map {|e| File.join(GIT_ROOT, e)}
        end
      end

      def modified_files
        diff_list('M')
      end

      def added_files
        diff_list('A')
      end
      
      def deleted_files
        diff_list('D')
      end

      def modified?(file_path)
        modified_files.include? file_path
      end

      def added?(file_path)
        added_files.include? file_path
      end

      def deleted?(file_path)
        deleted_files.include? file_path
      end

    end

  end
end
