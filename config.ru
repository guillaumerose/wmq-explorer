require 'bundler/setup'

Bundler.setup

require 'sinatra'
require 'json'
require 'wmq/wmq'
require 'rexml/document'

require './web'

use Rack::Static, :urls => {"/" => "index.html"}, :root => "public"

run Rack::URLMap.new({
  "/public" => Rack::Directory.new("public"),
  "/api"    => MqBrowser.new
})
