require 'verbs'

module ActsAsRelationship
  module Verb
    PATCHES = {
      'follow' => 'following'
    }

    def pastize
      verb.conjugate(tense: :past).split(' ').last
    end

    def progressize
      return PATCHES[self] if PATCHES.has_key?(self)

      verb.conjugate(aspect: :progressive).split(' ').last
    end

    # TODO: Implement this method more logically
    def peoplize
      chop! if last == 'e'

      self + 'ers'
    end
  end
end
