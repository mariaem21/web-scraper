class ApplicationCategoriesController < ApplicationController
  before_action :set_application_category, only: %i[ show edit update destroy ]

  # GET /application_categories or /application_categories.json
  def index
    @application_categories = ApplicationCategory.all
  end

  # GET /application_categories/1 or /application_categories/1.json
  def show
  end

  # GET /application_categories/new
  def new
    @application_category = ApplicationCategory.new
  end

  # GET /application_categories/1/edit
  def edit
  end

  # POST /application_categories or /application_categories.json
  def create
    @application_category = ApplicationCategory.new(application_category_params)

    respond_to do |format|
      if @application_category.save
        format.html { redirect_to application_category_url(@application_category), notice: "Application category was successfully created." }
        format.json { render :show, status: :created, location: @application_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_categories/1 or /application_categories/1.json
  def update
    respond_to do |format|
      if @application_category.update(application_category_params)
        format.html { redirect_to application_category_url(@application_category), notice: "Application category was successfully updated." }
        format.json { render :show, status: :ok, location: @application_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_categories/1 or /application_categories/1.json
  def destroy
    @application_category.destroy

    respond_to do |format|
      format.html { redirect_to application_categories_url, notice: "Application category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_category
      @application_category = ApplicationCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_category_params
      params.require(:application_category).permit(:application_category_id, :application_id, :category_id)
    end
end
