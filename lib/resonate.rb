require 'resonate/errors/argument_error'
require 'resonate/supports/converter'

module Resonate
  class << self
    def included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    include Resonate::Supports::Converter

    def resonate(subject, with: nil, by: nil, **options)
      @roles = { source: subject, target: with, action: by }
      @options = options

      if @roles.values.any?(&:nil?)
        raise Resonate::Errors::ArgumentError, 'Passed argument is not a valid'
      end

      classify(source).class_eval <<-EOS
        has_many :#{pluralize(action)},
          foreign_key: :#{source}_id,
          dependent: :destroy

        has_many :#{progressize(action)},
          through: :#{pluralize(action)},
          source: :target_#{target}

        def #{action}(target)
          if #{progressize(action)}?(target) || (self == target)
            return
          end

          #{pluralize(action)}.create(#{foreign_key}: target.id)
        end

        def un#{action}(target)
          unless #{progressize(action)}?(target)
            return
          end

          #{pluralize(action)}.find_by(#{foreign_key}: target.id).destroy
        end

        def #{progressize(action)}?(target)
          #{pluralize(action)}.exists?(#{foreign_key}: target.id)
        end
      EOS

      classify(target).class_eval <<-EOS
        has_many :#{pluralize(action)}_as_target,
          foreign_key: :#{foreign_key},
          class_name: '#{classify(action)}',
          dependent: :destroy

        has_many :#{peoplize(action)},
          through: :#{pluralize(action)}_as_target,
          source: :#{source}

        def #{pastize(action)}_by?(source)
          source.#{pluralize(action)}.exists?(#{foreign_key}: id)
        end
      EOS

      classify(action).class_eval <<-EOS
        belongs_to :#{source}

        belongs_to :target_#{target},
          class_name: '#{classify(target)}',
          foreign_key: :#{foreign_key}
      EOS
    end

    private

    def source
      @roles[:source].to_s
    end

    def target
      @roles[:target].to_s
    end

    def action
      @roles[:action].to_s
    end

    def foreign_key
      @options[:foreign_key] || "target_#{target}_id"
    end
  end
end
