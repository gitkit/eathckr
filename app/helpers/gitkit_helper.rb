module GitkitHelper

  def include_gitkit_headers
    if true # only do this if some flag is set...
      render 'gitkit/header'
    end
  end
  
end