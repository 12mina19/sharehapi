class Admin::HomesController < ApplicationController

  def top
    @categories = Category.all
  end
end
