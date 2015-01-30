require 'classifier'
class PredictionsController < ApplicationController
  before_action :set_prediction, only: [:show, :edit, :update, :destroy]

  # GET /predictions
  # GET /predictions.json
  def index
    @predictions = Prediction.all
  end

  # GET /predictions/1
  # GET /predictions/1.json
  def show
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new
  end

  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = Prediction.new(prediction_params)

    respond_to do |format|
      if @prediction.save
        make_prediction
        format.html { redirect_to @prediction, notice: 'Prediction was successfully created.' }
        format.json { render :show, status: :created, location: @prediction }
      else
        format.html { render :new }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /predictions/1
  # PATCH/PUT /predictions/1.json
  def update
    respond_to do |format|
      if @prediction.update(prediction_params)
        format.html { redirect_to @prediction, notice: 'Prediction was successfully updated.' }
        format.json { render :show, status: :ok, location: @prediction }
      else
        format.html { render :edit }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predictions/1
  # DELETE /predictions/1.json
  def destroy
    @prediction.destroy
    respond_to do |format|
      format.html { redirect_to predictions_url, notice: 'Prediction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:height, :weight, :result)
    end

    def make_prediction
      t = BayesClassifier::Trainer.new
      classifier = t.train
      result = classifier.classify([@prediction.height, @prediction.weight])
      @prediction.update(result: result)
    end
end