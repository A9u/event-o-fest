class Participant < ApplicationRecord
  enum rsvp: ['yes', 'no', 'maybe']

  belongs_to :event
  belongs_to :user
end
