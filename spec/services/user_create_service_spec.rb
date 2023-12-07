# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCreateService do
  subject(:service_response) { described_class.new(username, email, password).execute }

  context 'when user is valid' do
    let(:username) { 'test' }
    let(:email) { 'test@code0.tech' }
    let(:password) { 'test_password' }

    it { is_expected.to be_success }
    it { expect(service_response.payload).to be_valid }
    it('sets username correct') { expect(service_response.payload.username).to eq(username) }
    it('sets email correct') { expect(service_response.payload.email).to eq(email) }
    it('sets password correct') { expect(service_response.payload.password).to eq(password) }
  end

  context 'when user is invalid' do
    let!(:user_with_username) { create(:user, username: 'user') }
    let!(:user_with_email) { create(:user, email: 'test@code0.tech') }

    context 'when username is duplicated' do
      let(:username) { user_with_username.username }
      let(:email) { generate(:email) }
      let(:password) { generate(:password) }

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User is invalid') }
      it { expect(service_response.payload.full_messages).to include('Username has already been taken') }
    end

    context 'when email is duplicated' do
      let(:username) { generate(:username) }
      let(:email) { user_with_email.email }
      let(:password) { generate(:password) }

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User is invalid') }
      it { expect(service_response.payload.full_messages).to include('Email has already been taken') }
    end
  end

  context 'when invalid inputs are given' do
    context 'when username is nil' do
      let(:username) { nil }
      let(:email) { generate(:email) }
      let(:password) { generate(:password) }

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User is invalid') }
      it { expect(service_response.payload.full_messages).to include("Username can't be blank") }
    end

    context 'when email is nil' do
      let(:username) { generate(:username) }
      let(:email) { nil }
      let(:password) { generate(:password) }

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User is invalid') }
      it { expect(service_response.payload.full_messages).to include("Email can't be blank") }
    end

    context 'when password is nil' do
      let(:username) { generate(:username) }
      let(:email) { generate(:email) }
      let(:password) { nil }

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User is invalid') }
      it { expect(service_response.payload.full_messages).to include("Password can't be blank") }
    end
  end
end
