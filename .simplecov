# frozen_string_literal: true

SimpleCov.start do
  root ENV.fetch("ENGINE_ROOT", nil)

  add_filter "lib/generators"
  add_filter "/spec"
end

SimpleCov.command_name ENV.fetch("COMMAND_NAME", File.basename(Dir.pwd))

SimpleCov.merge_timeout 1800