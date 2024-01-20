# frozen_string_literal: true

class Person
  module Create
    module_function

    def create_person(params)
      person = Person.new(params)
      created = person.save

      [person, created]
    end

    def create_people(params)
      inserted_people = []
      failed_people = []

      params.each do |person_params|
        person = Person.new(person_params)

        if person.save
          inserted_people << person
        else
          failed_people << person
        end
      end

      [inserted_people, failed_people]
    end
  end
end
