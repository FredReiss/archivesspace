YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/templates'
require 'sinatra'

require 'jsonmodel'
require_relative '../backend/app/model/backend_enum_source.rb'

require_relative '../backend/app/lib/username.rb'

include JSONModel

JSONModel::init(:enum_source => BackendEnumSource)

require_relative '../backend/app/lib/rest.rb'


Dir[File.dirname(__FILE__) + '../backend/app/model/*.rb'].each {|file| require file }

require_relative 'handler'
require_relative 'schema_object'
# require_relative 'endpoint_object'

# Sub READMEs
# Silly workaround for YARD's non-support for READMEs and such
# that live in subdirectories of the project

class ASpaceYARD
  def self.subreadmes
    objects = []
    Dir.glob('{frontend,backend,common,migrations}/**/*.md').each do |file|
      objects << YARD::CodeObjects::ExtraFileObject.new(file.gsub(/\//, '_').upcase, IO.read(file))
    end
    objects
  end
end
    

module YARD
  module Templates
    module Engine
      class << self
        alias generate_old generate
        def generate(objects, options = {})
          options[:files] ||= []
          options[:files].concat(ASpaceYARD.subreadmes)
          generate_old(objects, options)
        end
      end
    end
  end
end

