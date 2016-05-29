require 'verbs'

module Resonance
  module Supports
    module Converter
      private

      def classify(str)
        str.camelize.constantize
      end

      def pluralize(str)
        str.pluralize
      end

      def progressize(str)
        if patches['progressize'].key?(str)
          return patches['progressize'][str]
        end

        str.verb.conjugate(aspect: :progressive).split(' ').last
      end

      def peoplize(str)
        str = (str.last == 'e') ? str.chop : str
        str + 'ers'
      end

      def pastize(str)
        str.verb.conjugate(tense: :past).split(' ').last
      end

      def patches
        @patches ||= YAML.load_file(patches_path)['patches']
      end

      def patches_path
        File.expand_path('../patches.yml', __FILE__)
      end
    end
  end
end
