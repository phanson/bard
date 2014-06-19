class PeopleController < ApplicationController
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(my_params)
    if @person.save
      redirect_to @person
    else
      render 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.update(params[:id], my_params)
    if @person.errors.count > 0
      render 'edit'
    else
      render 'show'
    end
  end

  def destroy
    Person.delete(params[:id])
    redirect_to people_path
  end

  private
  def my_params
    params.require(:person).permit(:name)
  end
end
