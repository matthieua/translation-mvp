class UsersController < ApplicationController
  def authorize
    if params[:oauth_token]
      dropbox_session = DropboxSession.deserialize(session[:dropbox_session])
      dropbox_session.get_access_token
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to :action => 'logged'
    else
      dropbox_session = DropboxSession.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.get_authorize_url(url_for(:action => 'authorize'))
    end
  end

  def logged
    dropbox_session = DropboxSession.deserialize(session[:dropbox_session])
    client = DropboxClient.new(dropbox_session, :app_folder)
    account = client.account_info
    User.create do |user|
      user.name        = account['display_name']
      user.email       = account['email']
      user.country     = account['country']
      user.dropbox_uid = account['dropbox_uid']
    end
  end
end