require 'csv'

desc 'upload event and its corresponding participants'
task :event_upload, [:file_name] => :environment do |t, args|
  errors = []

  CSV.foreach(args[:file_name], headers: true) do |row|
    event = Event.create(
      title: row['title'], description: row['description'],
      start_date: row['starttime'], end_date: row['endtime'],
      all_day: row['allday']
    )

    if event.persisted? && row['users#rsvp'].present?
      create_event_participants(event, row["users#rsvp"])
    end
  end
end

def create_event_participants(event, participants_rsvp)
  participants_rsvp.split(';').each do |participant_rsvp|
    username, rsvp = participant_rsvp.split("#")
    user = User.find_by(username: username)
    participant = Participant.new(event_id: event.id, user_id: user.id)
    if(rsvp == 'yes')
      earlier_events = Participant.joins(:event, :user)
        .where("users.id = ? AND date(events.start_date) = ? AND
               (((events.start_date between ? and ?) or (events.end_date between ? and ?)) OR
               ((? between events.start_date and events.end_date) or (? between events.start_date and events.end_date)
               )) and rsvp = ?",
               user.id, event.start_date.to_date, event.start_date, event.end_date, event.start_date, event.end_date,
               event.start_date, event.end_date, 0)

      earlier_events.update(rsvp: 'no')
    end

    participant.rsvp = rsvp
    participant.save
  end
end

