require 'spec_helper'

describe Constraints::HasUsers do
  subject(:constraint) { described_class.new }
  let(:request) { double('request') }

  describe '#matches?' do
    subject { constraint.matches?(request) }

    context 'given no users' do
      it { is_expected.to be_falsey }
    end

    context 'given a user' do
      before { create(:user) }
      it { is_expected.to be_truthy }
    end
  end
end
