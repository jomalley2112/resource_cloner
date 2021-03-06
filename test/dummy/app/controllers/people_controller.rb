class PeopleController < ApplicationController
  def index
    setup_pagination
    @people = Person.all
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      flash[:success] = "Created Person successfully"
      redirect_to people_url
    else
      flash[:error] = "Unable to create Person"
      render :new
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
      flash[:success] = "Updated Person successfully"
      redirect_to person_url(@person)
    else
      flash[:error] = "Unable to update Person"
      render :edit
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      flash[:success] = "Deleted Person successfully"
    else
      flash[:error] = "Unable to delete Person"
    end
    redirect_to people_url
  end

  private
   def person_params
      params.required(:person).permit([])
    end
end
