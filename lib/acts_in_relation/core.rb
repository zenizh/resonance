module ActsInRelation
  module Core
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_in_relation(position = :self, params)
        relation = Relation.new(position, params, class_name.call)
        relation.define
      end

      private

      # TODO: Implement this method to return reliable class name
      def class_name
        -> { caller_locations(3, 1)[0].label.match(/^\<class:(\w+)\>$/)[1].downcase.to_sym }
      end
    end

    class Relation
      def initialize(position, params, class_name)
        @position   = position
        @params     = params
        @class_name = class_name
      end

      def define
        positions = @position == :self ? [:source, :target] : [@position]
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
