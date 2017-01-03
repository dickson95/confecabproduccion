class ColoresController < ApplicationController
    def new
        @color = Color.new
    	
        respond_to do |wants|
            wants.html # create.html.erb
            wants.xml  { render :xml => @color }
        end
    end
end
