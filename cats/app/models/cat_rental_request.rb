class CatRentalRequest < ActiveRecord::Base

  validates :status, :cat_id, :start_date, :end_date, :user_id, presence: true
  validates :status, inclusion: { in: ["PENDING", "APPROVED", "DENIED"] }
  validate :approved_cat_requests_cannot_overlap
  validate :start_date_comes_before_end_date
  validate :cannot_overlap_pending_request_with_approved_request

  after_initialize { self.status ||= "PENDING" }

  belongs_to :cat, inverse_of: :rental_requests

  belongs_to :renter,
              class_name: "User",
              foreign_key: :user_id

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save!

      self.overlapping_pending_requests.each do |overlap|
        overlap.deny!
      end
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  def self.all_approved(cat_id)
    CatRentalRequest.where(cat_id: cat_id).where(status: "APPROVED")
  end

  def self.all_pending(cat_id)
    CatRentalRequest.where(cat_id: cat_id).where(status: "PENDING")
  end

  def overlapping_approved_requests
    overlaps = overlapping_requests
    return [] if overlaps.nil?
    overlaps.where(status: "APPROVED")
  end

  protected

    def overlapping_requests
      # if a start date is between another request's start and end date
      # for the same cat
      where_clause = <<-SQL
      ? BETWEEN cat_rental_requests.start_date AND cat_rental_requests.end_date
      OR
      ? BETWEEN cat_rental_requests.start_date AND cat_rental_requests.end_date
      SQL

      request = CatRentalRequest
        .joins("INNER JOIN cat_rental_requests AS request ON cat_rental_requests.cat_id = request.cat_id")
        .where(where_clause, start_date, end_date)

      if persisted?
        request
          .where("request.id = ?", self.id)
          .where("cat_rental_requests.id != request.id")
      else
        request
      end
    end

    def cannot_overlap_pending_request_with_approved_request
      unless overlapping_approved_requests.empty?
        errors[:cat_rental_request] << "can't overlap with an approved request"
      end
    end

    def overlapping_pending_requests
      overlaps = overlapping_requests
      return [] if overlaps.nil?
      overlaps.where(status: "PENDING")
    end

    def approved_cat_requests_cannot_overlap
      if self.status == "APPROVED" && !(overlapping_approved_requests.empty?)
        errors[:cat_rental_request] << "can't overlap with another rental request"
      end
    end

    def start_date_comes_before_end_date
      if self.start_date >= self.end_date
        errors[:start_date] << "can't come before end date"
      end
    end

end
