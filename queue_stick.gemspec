# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{queue_stick}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Balatero"]
  s.date = %q{2009-06-17}
  s.email = %q{david@bitwax.cd}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "design_docs/FEATURE_IDEAS",
     "examples/simple_mock_worker/echo_runner.rb",
     "examples/simple_mock_worker/echo_worker.rb",
     "examples/sqs_worker/simple_sqs_producer.rb",
     "examples/sqs_worker/simple_sqs_runner.rb",
     "examples/sqs_worker/simple_sqs_worker.rb",
     "lib/queue_stick.rb",
     "lib/queue_stick/blended_counter.rb",
     "lib/queue_stick/counter.rb",
     "lib/queue_stick/helpers.rb",
     "lib/queue_stick/message.rb",
     "lib/queue_stick/mock_message.rb",
     "lib/queue_stick/mock_worker.rb",
     "lib/queue_stick/runner.rb",
     "lib/queue_stick/sqs_message.rb",
     "lib/queue_stick/sqs_worker.rb",
     "lib/queue_stick/trap_hack.rb",
     "lib/queue_stick/views/index.erb",
     "lib/queue_stick/web_server.rb",
     "lib/queue_stick/window_counter.rb",
     "lib/queue_stick/worker.rb",
     "lib/queue_stick/worker_error.rb",
     "public/images/exclamation.png",
     "public/js/jquery.js",
     "public/stylesheets/main.css",
     "public/stylesheets/reset-fonts-grids.css",
     "spec/queue_stick/blended_counter_spec.rb",
     "spec/queue_stick/counter_spec.rb",
     "spec/queue_stick/helpers_spec.rb",
     "spec/queue_stick/message_spec.rb",
     "spec/queue_stick/mock_message_spec.rb",
     "spec/queue_stick/mock_worker_spec.rb",
     "spec/queue_stick/runner_spec.rb",
     "spec/queue_stick/sqs_message_spec.rb",
     "spec/queue_stick/sqs_worker_spec.rb",
     "spec/queue_stick/trap_hack_spec.rb",
     "spec/queue_stick/web_server_spec.rb",
     "spec/queue_stick/window_counter_spec.rb",
     "spec/queue_stick/worker_error_spec.rb",
     "spec/queue_stick/worker_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/dbalatero/queue_stick}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{This library allows you to write the minimal amount of code to process queue messages. Supports SQS out of the box.}
  s.test_files = [
    "spec/queue_stick/blended_counter_spec.rb",
     "spec/queue_stick/counter_spec.rb",
     "spec/queue_stick/helpers_spec.rb",
     "spec/queue_stick/message_spec.rb",
     "spec/queue_stick/mock_message_spec.rb",
     "spec/queue_stick/mock_worker_spec.rb",
     "spec/queue_stick/runner_spec.rb",
     "spec/queue_stick/sqs_message_spec.rb",
     "spec/queue_stick/sqs_worker_spec.rb",
     "spec/queue_stick/trap_hack_spec.rb",
     "spec/queue_stick/web_server_spec.rb",
     "spec/queue_stick/window_counter_spec.rb",
     "spec/queue_stick/worker_error_spec.rb",
     "spec/queue_stick/worker_spec.rb",
     "spec/spec_helper.rb",
     "examples/simple_mock_worker/echo_runner.rb",
     "examples/simple_mock_worker/echo_worker.rb",
     "examples/sqs_worker/simple_sqs_producer.rb",
     "examples/sqs_worker/simple_sqs_runner.rb",
     "examples/sqs_worker/simple_sqs_worker.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.2"])
      s.add_runtime_dependency(%q<right_aws>, [">= 1.10.0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.2"])
      s.add_dependency(%q<right_aws>, [">= 1.10.0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.2"])
    s.add_dependency(%q<right_aws>, [">= 1.10.0"])
  end
end
