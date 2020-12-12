class EventsController < ApplicationController
  def index
    @events = Event.where("(start_date between ? and ?) or (end_date between ? and ?)",
                          params[:from_date], params[:to_date], params[:from_date], params[:to_date]).page(params[:page])
  end
end
