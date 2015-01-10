module ActsInRelation
  module Core
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_in_relation(position = nil, params)
        @name   ||= class_name.call
        @params ||= params

        if position.in?([:source, :target, :action])
          send :include, "ActsInRelation::#{position.capitalize}".constantize
        end

        define
      end

      private

      def define
        acts_in_relation :source, {}
        acts_in_relation :target, {}
      end

      def source
        @source ||= @params[:source] || @name
      end

      def target
        @target ||= @params[:target] || @name
      end

      # TODO: Return instance if exists
      def with
        with = @params[:with]
        with = with.kind_of?(Array) ? with : [with]
        with.map(&:to_s)
      end

      # TODO: Implement this method to return reliable class name
      def class_name
        -> { caller_locations(3, 1)[0].label.match(/^\<class:(\w+)\>$/)[1].downcase.to_sym }
      end
    end
  end
end
