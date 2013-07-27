class UserDetailsController < ApplicationController

  def get_user_details
    @user_details = UserDetails.get_user_details(:username => params["username"])
  end

  def set_user_details
    @user_details = UserDetails.set_user_details(:fb_access_token => params[:fb_access_token])
    if @user_details[:err].blank?
      redirect_to "/user/#{@user_details["username"]}"
    else
      redirect_to "/", :notice => "Wrong facebook access token. Please provide a correct FB access token."
    end
  end
end
