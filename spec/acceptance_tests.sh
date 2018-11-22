#!/bin/bash

RACK_ENV=test rackup -p 9292 &
app_pid=$!

rake spec_accept

kill $app_pid