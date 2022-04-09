# frozen_string_literal: true

require 'rake_factory'

require_relative '../template'

module RakeTemplate
  module Tasks
    class Render < RakeFactory::Task
      default_name :render
      default_description(RakeFactory::DynamicValue.new do |t|
        "Render #{t.template_name ? "the #{t.template_name}" : 'a'} template"
      end)

      parameter :template_name
      parameter :template_file_path, required: true
      parameter :output_file_path, required: true
      parameter :vars, default: {}

      action do |t|
        $stdout.puts(
          "Rendering template at #{t.template_file_path} "\
          "to #{t.output_file_path}..."
        )
        template = Template.from_file(t.template_file_path)
        rendered = template.render(t.vars)
        mkdir_p(File.dirname(t.output_file_path))
        File.open(t.output_file_path, 'w') do |f|
          f.write(rendered)
        end
        $stdout.puts('Done.')
      end
    end
  end
end
