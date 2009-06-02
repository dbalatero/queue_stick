#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/echo_worker'

runner = QueueStick::Runner.new(ARGV)
runner.run!(EchoWorker)
