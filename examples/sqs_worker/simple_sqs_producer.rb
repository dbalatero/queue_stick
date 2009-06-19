#!/usr/bin/env ruby

require 'rubygems'
require 'right_aws'

sqs = RightAws::SqsGen2.new('<your access key>',
                            '<your secret key>',
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
