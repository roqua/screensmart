# frozen_string_literal: true

app_dir = File.expand_path('../..', __FILE__)
working_directory app_dir

worker_processes 4
preload_app true

listen '/app/tmp/sockets/unicorn.sock', backlog: 64
