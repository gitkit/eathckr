module GitkitHelper

  def include_gitkit_headers
    if true # only do this if some flag is set...
      render 'gitkit/header'
    end
  end
  
  def user_data
    if current_user
      obj = current_user.user_data
      obj[:signedIn] = true
      obj.to_json
    else
      {}.to_json
    end
  end
  
end