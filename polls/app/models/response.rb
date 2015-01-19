class Response < ActiveRecord::Base

  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cannot_respond_to_own_poll

  belongs_to :respondent,
    class_name: 'User',
    foreign_key: :respondent_id,
    primary_key: :id

  belongs_to :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id

  has_one :question, through: :answer_choice, source: :question

  def sibling_responses
    self.question.responses.where(<<-SQL, self_id: self.id)
      CASE
        WHEN :self_id IS NULL
          THEN responses.id IS NOT NULL
        ELSE
          responses.id <> :self_id
      END
    SQL
  end

  def annoying_sibling_responses
    Response
      .joins(answer_choice: :question)
      .where('a2.id = ?', 1)
      .joins('INNER JOIN answer_choices AS a2 ON questions.id = a2.question_id')
      .joins('INNER JOIN responses AS r2 ON a2.id = r2.answer_choice_id')
      .where(<<-SQL, self_id: self.id)
        CASE
          WHEN :self_id IS NULL
            THEN responses.id IS NOT NULL
          ELSE
            responses.id <> :self_id
        END
      SQL
      .distinct
  end

  private

  def respondent_has_not_already_answered_question
    if self.sibling_responses.pluck(:respondent_id).include?(self.respondent_id)
      errors[:base] << "Can't answer same question multiple times"
    end
  end

  def author_cannot_respond_to_own_poll
    author_id = Poll
                  .joins(questions: :answer_choices)
                  .where('answer_choices.id = ?', self.answer_choice_id)
                  .first.author_id
    if author_id == self.respondent_id
      errors[:base] << "Author cannot respond to own poll"
    end
  end

end
