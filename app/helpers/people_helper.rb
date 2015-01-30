module PeopleHelper
  def empty?
    Person.female.empty? || Person.male.empty?
  end
end
