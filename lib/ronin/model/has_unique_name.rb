#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/model/has_name'

module Ronin
  module Model
    #
    # Adds a unique `name` property to a model.
    #
    module HasUniqueName
      #
      # Adds the unique `name` property and {HasName::ClassMethods} to the
      # model.
      #
      # @param [Class] base
      #   The model.
      #
      # @api semipublic
      #
      def self.included(base)
        base.send :include, Model,
                            InstanceMethods

        base.send :extend,  HasName::ClassMethods,
                            HasUniqueName::ClassMethods

        base.module_eval do
          # The name of the model
          property :name, String, :required => true, :unique => true
        end
      end

      #
      # Class methods that will be added when {HasUniqueName} is included.
      #
      module ClassMethods
        #
        # Searches for models with the unique name.
        #
        # @param [String, Symbol, Integer] key
        #   The unique name or index to search for.
        #
        # @return [Model, nil]
        #   The matching model.
        #
        # @since 1.0.0
        #   
        # @api public
        #
        def [](key)
          case key
          when String, Symbol
            first(:name => key.to_s)
          else
            super(key)
          end
        end
      end

      #
      # Instance methods that will be added when {HasUniqueName} is
      # included.
      #
      module InstanceMethods
        #
        # Converts the named resource into a String.
        #
        # @return [String]
        #   The name of the resource.
        #
        # @since 1.0.0
        #
        # @api public
        #
        def to_s
          self.name.to_s
        end

        #
        # Inspects the resource with the unique name.
        #
        # @return [String]
        #   The inspected resource.
        #
        # @since 1.0.0
        #
        # @api public
        #
        def inspect
          "#<#{self.class}: #{self.name}>"
        end
      end
    end
  end
end
