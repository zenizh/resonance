require 'spec_helper'

describe Post, type: :model do
  let(:user) { User.create }
  let(:post) { Post.create }

  describe 'instance methods' do
    it 'should be defined' do
      # source: :user, action: :like
      expect(post).not_to respond_to(:like)
      expect(post).not_to respond_to(:unlike)
      expect(post).not_to respond_to(:liking?)
      expect(post).not_to respond_to(:liking)
      expect(post).to respond_to(:liked_by?)
      expect(post).to respond_to(:likers)
    end
  end

  describe '#liked_by?' do
    before { user.like post }

    it 'should be liked by user' do
      expect(post).to be_liked_by(user)
    end
  end

  describe '#likers' do
    before { user.like post }

    it 'should be included user' do
      expect(post.likers).to be_exists(id: user.id)
    end
  end
end
