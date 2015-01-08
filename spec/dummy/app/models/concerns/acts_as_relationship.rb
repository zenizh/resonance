module ActsAsRelationship
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_relation_source(name, with:)
      with = *with

      with.each do |w|
        has_many :"#{w}s",           dependent: :destroy
        has_many :"#{w}s_as_target", dependent: :destroy, class_name: w.to_s.capitalize, foreign_key: :"target_#{name}_id"

        # TODO: Don't use 'user'
        self.class_eval <<-RUBY
          def #{w}(user)
            #{w.pluralize}.create(target_#{name}_id: user.id)
          end

          def un#{w}(user)
            return unless #{w}ing?(user)

            #{w.pluralize}.find_by(target_#{name}_id: user.id).destroy
          end

          def #{w}ing?(user)
            #{w.pluralize}.exists?(target_#{name}_id: user.id)
          end

          def #{w}ed_by?(user)
            user.#{w.pluralize}.exists?(#{name}_id: user.id)
          end
        RUBY

        # user.following

        # user.followers

        # user.followed_by?
      end
    end

    def acts_as_relation_target(name)
      belongs_to :"#{name}"
      belongs_to :"target_#{name}", class_name: name.to_s.capitalize, foreign_key: :"target_#{name}_id"
    end
  end
end
