require 'spec_helper'

describe FirstAccountsController do
  describe '#create' do
    subject do
      post :create, user: {
        email: 'first-account@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    it 'creates the first account' do
      expect { subject }.to change { User.count }.by(1)
    end

    it { is_expected.to redirect_to(edit_settings_path) }
  end
end
