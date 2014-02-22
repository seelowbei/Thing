class Question < ActiveRecord::Base

	attr_accessor :from_date, :till_date

	def self.search(opts = {})
		base_query = Question.all
		unless opts[:from_date].blank? 
		base_query.where("created_at >= ?", opts[:from_date]) 
		puts "form_date"
		end
		unless opts[:till_date].blank?
		base_query.where("created_at < ?", opts[:till_date].to_date.tomorrow)	
		puts "till_date"
		end

		base_query
	end	

	def self.to_csv(options = {})
      CSV.generate(options) do |writer| 
        writer << ["Date",  "Question"] 
        all.each do |row|
          writer << [row["created_at"].strftime("%d/%m/%Y %I:%M %P"), row["question_text"]]
        end
      end
    end
end
