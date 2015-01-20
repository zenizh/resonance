require 'caller_class'

module ActsInRelation
  module Core
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include CallerClass

      def acts_in_relation(position = :self, params)
        relation = Relation.new(position, params, caller_class.downcase)
        relation.define
      end
    end

    class Relation
      def initialize(position, params, class_name)
        @position   = position
        @params     = params
        @class_name = class_name
      end

      def define
        positions = (@position == :self) ? [:source, :target] : [@position]
        positions.each do |position|
          extend "ActsInRelation::#{position.capitalize}".constantize
          define
        end
      end

      private

      def source
        @source ||= @params[:source] || @class_name
      end

      def target
        @target ||= @params[:target] || @class_name
      end

      # TODO: Return instance if exists
      def with
        with = @params[:with]
        with = with.kind_of?(Array) ? with : [with]
        with.map(&:to_s)
      end

      def class_object
        @class_object ||= @class_name.to_s.capitalize.constantize
      end
    end
  end
end
