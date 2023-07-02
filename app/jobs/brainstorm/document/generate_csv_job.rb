class Brainstorm::Document::GenerateCsvJob < ApplicationJob
  require "csv"

  def perform(brainstorm, visitor_id)

    generate_csv_file(brainstorm)

    brainstorm.csv.attach(
      io: @tempfile,
      filename: "#{brainstorm.token}_export.csv",
      content_type: "application/CSV")
    brainstorm.csv.save
  end

  after_perform do |job|
    brainstorm = job.arguments[0]
    visitor_id = job.arguments[1]
    
    brainstorm.document.done(visitor_id, :csv)
  end

  def generate_csv_file(brainstorm)
    @tempfile = Tempfile.new(["#{brainstorm.token}-", '.csv']).tap do |file|
      CSV.open(file, 'wb') do |csv|
        # CSV Header Row
        if !brainstorm.anonymous?
          csv << %w[Ideas IdeaBuilds Votes Author]
        else
          csv << %w[Ideas IdeaBuilds Votes]
        end
  
        # CSV Rows, each row representing an idea
        brainstorm.ideas.order('votes DESC').each do |idea|
          builds = idea.idea_builds.map { |idea_build| idea_build.idea_build_text }
  
          if !brainstorm.anonymous?
            csv << [
              "#" + idea.number.to_s + ": " + idea.text,
              "-",
              idea.votes,
              idea.author
            ]
          else
            csv << [
              "#" + idea.number.to_s + ": " + idea.text,
              "-",
              idea.votes
            ]
          end
  
          idea.idea_builds.each do |idea_build|
            if !brainstorm.anonymous?
              csv << [
                "-",
                "#" + idea.number.to_s + "." + idea_build.decimal.to_s + ": " + idea_build.idea_build_text,
                "-",
                idea_build.author
              ]
            else
              csv << [
                "-",
                "#" + idea.number.to_s + "." + idea_build.decimal.to_s + ": " + idea_build.idea_build_text,
                "-"
              ]
            end
          end
        end
      end
    end
  end
  
end

