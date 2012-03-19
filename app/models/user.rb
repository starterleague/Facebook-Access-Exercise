class User < ActiveRecord::Base
  has_secure_password
  
  def facebook_name
    if self.facebook_access_token
      me_response = open("https://graph.facebook.com/me?access_token=#{self.facebook_access_token}").read
      me_json = JSON.parse(me_response)
      if me_json["name"]
        return me_json["name"]
      end
    end
    return nil
  end
  
  def facebook_image_uri
    if self.facebook_name
      return open("https://graph.facebook.com/me/picture?access_token=#{self.facebook_access_token}").base_uri
    else
      return nil
    end
  end
  
  def facebook_links
    if self.facebook_name
      links_response = open("https://graph.facebook.com/me/links?access_token=#{self.facebook_access_token}").read
      return JSON.parse(links_response)["data"]
    else
      return nil
    end
  end
end
