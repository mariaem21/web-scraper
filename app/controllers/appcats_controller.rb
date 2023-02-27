# frozen_string_literal: true

class AppcatsController < ApplicationController
  before_action :set_appcat, only: %i[show edit update destroy]

  # GET /appcats or /appcats.json
  def index
    @appcats = Appcat.all
  end

  # GET /appcats/1 or /appcats/1.json
  def show; end

  # GET /appcats/new
  def new
    @appcat = Appcat.new
  end

  # GET /appcats/1/edit
  def edit; end

  # POST /appcats or /appcats.json
  def create
    @appcat = Appcat.new(appcat_params)

    respond_to do |format|
      if @appcat.save
        format.html { redirect_to appcat_url(@appcat), notice: 'Appcat was successfully created.' }
        format.json { render :show, status: :created, location: @appcat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appcat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appcats/1 or /appcats/1.json
  def update
    respond_to do |format|
      if @appcat.update(appcat_params)
        format.html { redirect_to appcat_url(@appcat), notice: 'Appcat was successfully updated.' }
        format.json { render :show, status: :ok, location: @appcat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appcat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appcats/1 or /appcats/1.json
  def destroy
    @appcat.destroy

    respond_to do |format|
      format.html { redirect_to appcats_url, notice: 'Appcat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appcat
    @appcat = Appcat.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appcat_params
    params.require(:appcat).permit(:appcatID, :categoryID, :applicationID)
  end
end
