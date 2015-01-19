class Question < ActiveRecord::Base

  validates :poll, presence: true
  validates :text, presence: true

  belongs_to :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id

  has_many :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id,
    dependent: :destroy

  has_many :responses, through: :answer_choices, source: :responses

  def results
    answers = self.answer_choices
      .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
      .group('answer_choices.id')
      .select('answer_choices.*, COUNT(responses.id) AS response_count')

    results = {}
    answers.each do |answer_choice|
      results[answer_choice.text] = answer_choice.response_count
    end
    results
  end

  def delete
    self.destroy
  end

end
