# Added this unshift back in so that files can arbitrarily include this
# file and get the library in.
$LOAD_PATH.unshift(File.dirname(__FILE__))

########## THIS SUCKS TAKE IT OUT ##############
# (as soon as 
#   http://github.com/dbalatero/sinatra/commit/5fb4d1904dbbd79dfe3f06c9868c0603baf4dd80 is merged into Sinatra)
##########
require 'queue_stick/trap_hack'


# External deps
require 'rubygems'
require 'right_aws'
require 'sinatra/base'

require 'queue_stick/helpers'
require 'queue_stick/counter'
require 'queue_stick/window_counter'
require 'queue_stick/blended_counter'

require 'queue_stick/message'
require 'queue_stick/mock_message'
require 'queue_stick/sqs_message'

require 'queue_stick/runner'
require 'queue_stick/web_server'
require 'queue_stick/worker'
require 'queue_stick/worker_error'

require 'queue_stick/mock_worker'
require 'queue_stick/sqs_worker'

module QueueStick
end
