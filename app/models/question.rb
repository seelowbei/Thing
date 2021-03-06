class Question < ActiveRecord::Base

	include Humanizer
    require_human_on :create, :unless => :bypass_humanizer
	attr_accessor :from_date, :till_date, :bypass_humanizer

	validate do
    	errors.add(:base, "Please enter your question.") if question_text.blank?
    end

	def self.search(opts = {})
		base_query = Question.all
		base_query = base_query.where("created_at >= ?", opts[:from_date].to_date) unless opts[:from_date].blank?
		base_query = base_query.where("created_at < ?", opts[:till_date].to_date.tomorrow) unless opts[:till_date].blank?
		base_query
	end

	def self.check_date_request?(opts = {})
		opts[:from_date].to_date >  opts[:till_date].to_date unless opts[:from_date].blank? or opts[:till_date].blank?
	end

	def self.to_csv
      CSV.generate do |writer|
        writer << ["Date",  "Question"]
        all.each do |row|
          writer << [row["created_at"].strftime("%d/%m/%Y %I:%M %P"), row["question_text"]]
        end
      end
    end
end
