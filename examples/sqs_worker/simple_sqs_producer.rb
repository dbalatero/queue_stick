#!/usr/bin/env ruby

require 'rubygems'
require 'right_aws'

sqs = RightAws::SqsGen2.new('1N2G2X8M88XC4KTYRHG2',
                            'yQHr7PhLOfBkpnaK1MbPBcDxKKO6snAW500f3Lyl',
                            :multi_thread => false,
                            :signature_version => '1')
queue = sqs.queue('my_test_queue', true)

i = 1
while true
  print "[#{i}] Enter a message to put to SQS: "
  message = gets
  queue.push(message)
  i += 1
end
