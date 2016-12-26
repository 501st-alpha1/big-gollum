require 'spec_helper'

describe SettingsController do
  let(:user) { create(:user) }
  before { sign_in(user) }

  describe '#show' do
    subject { get :show }

    context 'given no persistent settings' do
      before { subject }

      it 'assigns an instance var with 1 setting' do
        expect(assigns(:settings).first).to be_a_new(Setting)
      end

      it 'returns an array of size 1' do
        expect(assigns(:settings).size).to eq(1)
      end

      it 'contains a setting for application_name' do
        expect(assigns(:settings).first.key).to eq "application_name"
      end
    end

    context 'given persistent settings' do
      let!(:setting) { Setting.create(key: "application_name", value: "#33000") }

      it 'assigns an instance var with existing settings' do
        subject
        expect(assigns(:settings)).to eq([setting])
      end
    end
  end

  describe '#update' do
    context "given valid input" do
      subject { put :update, settings: {application_name: {value: 'Hello'} } }

      it 'sets the settings' do
        expect { subject }.to change { Setting.count }.by(1)
      end

      context 'and an existing setting' do
        before { Setting.create(key: "application_name", value: "old_name") }

        it 'updates existing settings' do
          expect { subject }.to_not change { Setting.count }
        end
      end
    end

    context "given invalid input" do
      subject { put :update, settings: {application_name: {value: nil} } }

      it 'does not save any settings' do
        expect { subject }.to_not change { Setting.count }
      end

      it 'gives a flash with error message' do
        subject
        expect(flash[:error]).to eq "Could not save settings"
      end
    end
  end
end
