require 'spec_helper'

describe Setting do
  describe '.value_for' do
    subject {Setting.value_for('application_name')}
    context "no stored value" do

      it 'returns the default value' do
        expect(subject).to eq "Big Gollum"
      end

    end

    context 'has a stored value' do
      let(:stored_value) { "A new world of wikis" }
      before { Setting.create!(key: "application_name", value: stored_value) }

      it 'returns the stored value' do
        expect(subject).to eq stored_value
      end
    end
  end
end