# frozen_string_literal: true

require 'rake_template/tasks'
require 'rake_template/version'

module RakeTemplate
  def self.define_render_task(opts = {}, &)
    RakeTemplate::Tasks::Render.define(opts, &)
  end
end
