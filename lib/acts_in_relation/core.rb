module ActsInRelation
  module Core
    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      # DSL called to a subclass of ActiveRecord::Base
      #
      # @param [Hash] args Define relation with :role, :action, :source, :target or :self.
      #
      # @example Define self relation
      #   class User < ActiveRecord::Base
      #     acts_in_relation role: :self, action: [:follow, :block]
      #   end
      #
      #   class Follow < ActiveRecord::Base
      #     acts_in_relation role: :action, self: :user
      #   end
      #
      #   class Block < ActiveRecord::Base
      #     acts_in_relation role: :action, self: :user
      #   end
      #
      # @example Define relation of each models
      #   class User < ActiveRecord::Base
      #     acts_in_relation role: :source, target: :post, action: :like
      #   end
      #
      #   class Post < ActiveRecord::Base
      #     acts_in_relation role: :target, source: :user, action: :like
      #   end
      #
      #   class Like < ActiveRecord::Base
      #     acts_in_relation role: :action, source: :user, target: :post
      #   end
      def acts_in_relation(**args)
        @args = args

        case @args[:role]
        when nil
          raise ActsInRelation::MissingRoleError
        when :source
          define_source
        when :target
          define_target
        when :action
          define_action
        when :self
          define_source
          define_target
        else
          raise ActsInRelation::UnknownRoleError, @args[:role]
        end
      end

      private

      def define_source
        ActsInRelation::Roles::Source.new(@args).define
      end

      def define_target
        ActsInRelation::Roles::Target.new(@args).define
      end

      def define_action
        ActsInRelation::Roles::Action.new(@args).define
      end
    end
  end
end
