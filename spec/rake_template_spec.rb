# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RakeTemplate do
  it 'has a version number' do
    expect(RakeTemplate::VERSION).not_to be_nil
  end

  describe 'define_render_task' do
    context 'when instantiating RakeTemplate::Tasks::Render' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'passes the provided block' do
        opts = {
          template_file_path: 'some/template/file',
          output_file_path: 'some/output/file'
        }

        block = lambda do |t|
          t.vars = {
            first: 'one',
            second: 'two'
          }
        end

        allow(RakeTemplate::Tasks::Render).to(receive(:define))

        described_class.define_render_task(opts, &block)

        expect(RakeTemplate::Tasks::Render)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
