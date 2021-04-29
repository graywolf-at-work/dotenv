require "open3"

module Dotenv
  # This class enables parsing of a string for key value pairs to be returned
  # and stored in the Environment using native POSIX compatible shell.
  class NativeShellParser
    def self.works?
      @posix_shell_working ||= posix_shell_working?
    end

    def self.call(read, is_load = false)
      Parser.call(read, is_load)
    end

    def self.posix_shell_working?
      return false if ENV.fetch("DOTENV_NO_NATIVE_PARSER", nil)

      sh = ENV.fetch("SHELL", "sh")

      opts = { stdin_data: "" }
      _, s = Open3.capture2e(sh, opts)
      return false unless s.success?

      opts = { stdin_data: "for x in 1 2 3; do printf '%02d, ' $x; done" }
      o, s = Open3.capture2e(sh, opts)
      return false unless s.success?

      o == "01, 02, 03, "
    end
    private_class_method :posix_shell_working?
  end
end
