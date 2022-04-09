# frozen_string_literal: true

require 'rake_template/tasks'
require 'rake_template/version'

module RakeTemplate
  def self.define_render_task(opts = {}, &block)
    RakeTemplate::Tasks::Render.define(opts, &block)
  end
end
