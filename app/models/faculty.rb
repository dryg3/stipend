class Faculty < ActiveRecord::Base
	has_many :account_to_semesters
	has_many :pay_category_to_semesters
	has_many :groups
  has_many :users
  has_many :orders
	validates_uniqueness_of :name,
		message: "Название факультета должно быть уникально" 
	validates_presence_of :name,
		message: "Название факультета должно быть заполнино"
end
