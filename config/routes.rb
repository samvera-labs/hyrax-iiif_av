# frozen_string_literal: true
Hyrax::IiifAv::Engine.routes.draw do
  get '/iiif_av/content/:id/:label', to: 'iiif_av#content', as: :iiif_av_content
  get '/iiif_av/auth_token/:id', to: 'iiif_av#auth_token', as: :iiif_av_auth_token
  get '/iiif_av/sign_in', to: 'iiif_av#sign_in', as: :iiif_av_sign_in
end
