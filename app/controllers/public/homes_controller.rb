class Public::HomesController < ApplicationController

  def top
    @categories = Category.all
  end

end
