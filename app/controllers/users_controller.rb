class UsersController < ApplicationController
  before_filter :ensure_signed_in, :only => :authorize

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      self.current_user = @user
      authorize_dropbox_account
    else
      render "new"
    end
  end

  def authorize
    if params[:oauth_token]
      dropbox_session = DropboxSession.deserialize(session[:dropbox_session])
      client          = DropboxClient.new(dropbox_session, :dropbox)
      account         = client.account_info

      dropbox_session.get_access_token

      user = User.find(params['id'])
      user.name        = account['display_name']
      user.email       = account['email']
      user.country     = account['country']
      user.dropbox_uid = account['uid']
      user.save

      root_directory = 'Translation'
      client.file_create_folder("#{root_directory}/french-to-english")
      client.file_create_folder("#{root_directory}/englisgh-to-french")

      redirect_to root_path, :notice => 'Dropbox account authorized successfully'
    else
      authorize_dropbox_account
    end
  end

  private

  def authorize_dropbox_account
    dropbox_session = DropboxSession.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
    session[:dropbox_session] = dropbox_session.serialize

    redirect_to dropbox_session.get_authorize_url(url_for(:action => 'authorize', :id => current_user))
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end