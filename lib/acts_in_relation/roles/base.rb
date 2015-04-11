require 'caller_class'

module ActsInRelation
  module Roles
    class Base
      include CallerClass
      include ActsInRelation::Supports::Verb

      def initialize(args)
        @class = caller_class.constantize
        @args = recursive_to_s(args)
      end

      def source
        @source ||= @args[:source] || @args[:self] || @class.to_s.downcase
      end

      def target
        @target ||= @args[:target] || @args[:self] || @class.to_s.downcase
      end

      def actions
        @actions ||= [@args[:action]].flatten
      end

      def define
        raise NotImplementedError
      end

      private

      def recursive_to_s(object)
        case object
        when Hash
          object.each do |k, v|
            object[k] = recursive_to_s(v)
          end
        when Array
          object.map { |o| recursive_to_s(o) }
        else
          object.to_s unless object.nil?
        end
      end
    end
  end
end
