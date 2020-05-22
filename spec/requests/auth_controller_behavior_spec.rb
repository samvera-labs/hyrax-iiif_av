# frozen_string_literal: true

require 'rails_helper'

describe Hyrax::IiifAv::AuthControllerBehavior, type: :request do
  describe 'after_sign_in_path_for' do
    let(:user) { FactoryBot.create(:user) }
    let(:login_params) { { user: { email: user.user_key, password: user.password, remember_me: 0 }, commit: "Log in" } }

    it 'redirects to self closing page when iiif_auth_login parameter present' do
      headers = { "HTTP_REFERER" => Rails.application.routes.url_helpers.new_user_session_path(iiif_auth_login: true) }
      post(Rails.application.routes.url_helpers.new_user_session_path, params: login_params, headers: headers)
      expect(response).to redirect_to Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_sign_in_path
    end

    it 'redirects to the dashboard' do
      headers = { "HTTP_REFERER" => Rails.application.routes.url_helpers.new_user_session_path }
      post(Rails.application.routes.url_helpers.new_user_session_path, params: login_params, headers: headers)
      expect(response).to redirect_to Hyrax::Engine.routes.url_helpers.dashboard_path(locale: I18n.locale)
    end

    context 'when already logged in' do
      before do
        sign_in user
      end

      it 'redirects to self closing page when iiif_auth_login parameter present' do
        get(Rails.application.routes.url_helpers.new_user_session_path(iiif_auth_login: true))
        expect(response).to redirect_to Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_sign_in_path
      end

      it 'redirects to the dashboard' do
        get(Rails.application.routes.url_helpers.new_user_session_path)
        expect(response).to redirect_to Hyrax::Engine.routes.url_helpers.dashboard_path(locale: I18n.locale)
      end
    end
  end
end
