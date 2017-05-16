class WelcomeController < ApplicationController
  def index
    render :file => 'public/index.html'
  end

  def example
    render file: 'public/example.html'
  end
end
