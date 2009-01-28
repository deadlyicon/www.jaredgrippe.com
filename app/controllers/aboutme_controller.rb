class AboutmeController < ApplicationController
  
  def index
  end
  
  def foaf
    respond_to do |format|
      format.rdf
    end
  end
  
end
