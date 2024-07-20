class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :update]

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      render json: @survey, status: :created
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @survey.to_json(include: :components)
  end

  def update
    if @survey.update(survey_params)
      update_components if params[:survey][:components_attributes]
      render json: @survey
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  private

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(
      :name, 
      :description,
      components_attributes: [:component_details]
    )
  end

  def update_components
    @survey.transaction do
      if @survey.components 
        @survey.components.destroy_all
      end  
      params[:survey][:components_attributes].each do |component_params|
        Component.create(survey_id: @survey.id, component_details: component_params)
      end
    end
  end
end
