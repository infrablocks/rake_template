# frozen_string_literal: true

require 'spec_helper'

describe RakeTemplate::Tasks::Render do
  include_context 'rake'

  before do
    stub_output
  end

  def define_task(opts = {}, &block)
    opts = { namespace: :template }.merge(opts)

    namespace opts[:namespace] do
      described_class.define(opts, &block)
    end
  end

  it 'adds a render task in the namespace in which it is created' do
    define_task(
      template_file_path: 'some/template/file.erb',
      output_file_path: 'some/output/file.txt'
    )

    expect(Rake.application)
      .to(have_task_defined('template:render'))
  end

  it 'gives the render task a default description' do
    define_task(
      template_file_path: 'some/template/file.erb',
      output_file_path: 'some/output/file.txt'
    )

    expect(Rake::Task['template:render'].full_comment)
      .to(eq('Render a template'))
  end

  it 'uses the template name in the task description when provided' do
    define_task(
      template_name: 'important thing',
      template_file_path: 'some/template/file.erb',
      output_file_path: 'some/output/file.txt'
    )

    expect(Rake::Task['template:render'].full_comment)
      .to(eq('Render the important thing template'))
  end

  it 'fails if no template file path is provided' do
    define_task(
      template_name: 'important thing',
      output_file_path: 'some/output/file.txt'
    )

    expect do
      Rake::Task['template:render'].invoke
    end.to(raise_error(RakeFactory::RequiredParameterUnset,
                       /template_file_path/))
  end

  it 'fails if no output file path is provided' do
    define_task(
      template_name: 'important thing',
      template_file_path: 'some/template/file.erb'
    )

    expect do
      Rake::Task['template:render'].invoke
    end.to(raise_error(
             RakeFactory::RequiredParameterUnset, /output_file_path/
           ))
  end

  it 'has no vars by default' do
    define_task(
      template_file_path: 'some/template/file.erb',
      output_file_path: 'some/output/file.txt'
    )

    expect(Rake::Task['template:render'].creator.vars).to(eq({}))
  end

  it 'uses the supplied vars when provided' do
    define_task(
      template_file_path: 'some/template/file.erb',
      output_file_path: 'some/output/file.txt',
      vars: {
        first_thing: 'one',
        second_thing: 'two'
      }
    )

    expect(Rake::Task['template:render'].creator.vars)
      .to(eq({
               first_thing: 'one',
               second_thing: 'two'
             }))
  end

  it 'renders the template at the template file path and writes the result ' \
     'to the output file path' do
    output_file_path = 'some/output/file.txt'
    template_file_path = 'some/template/file.erb'
    template_file_contents = "Hello <%= @name %>,\nToday is <%= @date %>"
    vars = {
      name: 'Alice',
      date: '2020-05-08'
    }

    FileUtils.mkdir_p(File.dirname(template_file_path))
    File.open(template_file_path, 'w') do |f|
      f.write(template_file_contents)
    end

    define_task(
      template_file_path:,
      output_file_path:,
      vars:
    )

    Rake::Task['template:render'].invoke

    output_file_contents = File.read(output_file_path)

    expect(output_file_contents).to(eq("Hello Alice,\nToday is 2020-05-08"))
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end
end
