# frozen_string_literal: true

class PeopleController < ApplicationController
  PERMITTED_ATTRS = %i[first_name last_name passport_series passport_number passport_issued_by
                       passport_issued_on].freeze

  def index
    render json: Person.all
  end

  def show
    render json: Person.find(params[:id])
  end

  def create
    if params[:person].present?
      create_person(*Person::Create.create_person(person_params))
    elsif params[:people].present?
      create_people(*Person::Create.create_people(people_params))
    else
      render json: { error: 'Please provide `person` or `people` argument' }, status: :bad_request
    end
  end

  private

  def create_person(person, created)
    if created
      render json: { person:, url: person_url(person) }, status: :created, location: person
    else
      render json: person.errors, status: :unprocessable_entity
    end
  end

  def create_people(inserted_people, failed_people)
    if failed_people.empty?
      render json: inserted_people, status: :created
    else
      render json: {
        inserted: inserted_people.map { |person| { person:, url: person_url(person) } },
        failed: failed_people
      }, status: :multi_status
    end
  end

  def person_params
    params.require(:person).permit(*PERMITTED_ATTRS)
  end

  def people_params
    params.require(:people).map { |person_params| person_params.permit(*PERMITTED_ATTRS) }
  end
end
