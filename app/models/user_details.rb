class UserDetails < ActiveRecord::Base
  attr_accessible :user_id, :username, :name, :gender, :hometown, :location, :bio

  def self.set_user_details(params)
    return {:err => "err", :message => "Please provide the fb access token"} if params[:fb_access_token].blank?

    begin
      Timeout::timeout(15) do
        request = "curl   'https://graph.facebook.com/me?access_token=#{params[:fb_access_token]}'"
        resp = `#{request}`
        if resp["error"].blank?
          resp = JSON.parse(resp)
          entry_exists = where("username = ?", resp["username"]).first
          user_detail = {:user_id => resp["id"],
                         :username => resp["username"],
                         :name => resp["name"],
                         :gender => resp["gender"],
                         :hometown => resp["hometown"]["name"],
                         :location => resp["location"]["name"],
                         :bio => resp["bio"]}

          if entry_exists.present?
           update_all(["name = ?, gender = ? , hometown = ?, location = ?, bio = ?",
                       user_detail["name"], user_detail["gender"], user_detail["hometown"], user_detail["location"], user_detail["bio"]],
                      ['username = ?',user_detail["username"]])
          else
            create!(user_detail)
          end
          return resp
        else
          return {:err => "err1", :message => "Something went wrong while trying to access the user details. Please try again."}
        end
      end
    end
  end

  def self.get_user_details(params)
    return {:err => "err0", :message => "Please type username in url."} if params[:username].blank?
    user_details = where(:username => params[:username]).first
    return {:err => "err1", :message => "No user found in database."} if user_details.blank?
    user_details
  end
end
