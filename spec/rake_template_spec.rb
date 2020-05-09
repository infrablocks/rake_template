require 'spec_helper'

RSpec.describe RakeTemplate do
  it 'has a version number' do
    expect(RakeTemplate::VERSION).not_to be nil
  end

  context 'define_render_task' do
    context 'when instantiating RakeTemplate::Tasks::Render' do
      it 'passes the provided block' do
        opts = {
            template_file_path: 'some/template/file',
            output_file_path: 'some/output/file',
        }

        block = lambda do |t|
          t.vars = {
              first: "one",
              second: "two"
          }
        end

        expect(RakeTemplate::Tasks::Render)
            .to(receive(:define) do |passed_opts, &passed_block|
              expect(passed_opts).to(eq(opts))
              expect(passed_block).to(eq(block))
            end)

        RakeTemplate.define_render_task(opts, &block)
      end
    end
  end
end
