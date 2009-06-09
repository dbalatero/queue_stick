#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/simple_sqs_worker'

runner = QueueStick::Runner.new(ARGV)
runner.run!(SimpleSQSWorker)
