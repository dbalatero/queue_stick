require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'queue_stick'

# Don't register trap(:INT) for our specs.
$DISABLE_TRAPS = true
$SINATRA_ENV = 'test'

require 'spec/interop/test'
require 'rack/test'

Test::Unit::TestCase.send(:include, Rack::Test::Methods)

Spec::Runner.configure do |config|
end
