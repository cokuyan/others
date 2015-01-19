class User < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  has_many :authored_polls,
            class_name: 'Poll',
            foreign_key: :author_id,
            primary_key: :id

  has_many :responses,
            class_name: 'Response',
            foreign_key: :respondent_id,
            primary_key: :id

  def uncompleted_polls
    subquery = <<-SQL
      SELECT
        responses.*
      FROM
        responses
      INNER JOIN
        users ON responses.respondent_id = users.id
      WHERE
        users.id = #{self.id}
    SQL

    Poll
    .select('polls.*, COUNT(DISTINCT questions.id) AS question_count')
    .joins(questions: :answer_choices)
    .joins("LEFT OUTER JOIN (#{subquery}) AS user_responses ON user_responses.answer_choice_id = answer_choices.id")
    .group('polls.id')
    .having('COUNT(user_responses.id) BETWEEN 1 AND (COUNT(DISTINCT questions.id) - 1)')
  end

  def completed_polls
    subquery = <<-SQL
      SELECT
        responses.*
      FROM
        responses
      INNER JOIN
        users ON responses.respondent_id = users.id
      WHERE
        users.id = #{self.id}
    SQL

    Poll
      .select('polls.*, COUNT(DISTINCT questions.id) AS question_count')
      .joins(questions: :answer_choices)
      .joins("LEFT OUTER JOIN (#{subquery}) AS user_responses ON user_responses.answer_choice_id = answer_choices.id")
      .group('polls.id')
      .having('COUNT(user_responses.id) = COUNT(DISTINCT questions.id)')

    # Poll.find_by_sql([<<-SQL, self.id])
    #   SELECT
    #     polls.*, COUNT(DISTINCT questions.id) AS question_count
    #   FROM
    #     polls
    #   INNER JOIN
    #     questions ON polls.id = questions.poll_id
    #   INNER JOIN
    #     answer_choices ON answer_choices.question_id = questions.id
    #   LEFT OUTER JOIN # joins('LEFT OUTER JOIN #{subquery} AS w/e')
    #     (
    #       SELECT
    #         responses.*
    #       FROM
    #         responses
    #       INNER JOIN
    #         users ON responses.respondent_id = users.id
    #       WHERE
    #         users.id = ?
    #     ) AS user_responses ON user_responses.answer_choice_id = answer_choices.id
    #   GROUP BY
    #     polls.id
    #   HAVING
    #     COUNT(user_responses.id) = COUNT(DISTINCT questions.id)
    # SQL
  end
end
