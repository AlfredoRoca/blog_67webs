require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

use Rack::ConditionalGet
use Rack::ETag

require 'nesta/env'
Nesta::Env.root = ::File.expand_path('.', ::File.dirname(__FILE__))

require 'nesta/app'

use Rack::Codehighlighter, :coderay, :element => "pre>code", :markdown => true, :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

run Nesta::App
