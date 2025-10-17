# db/seeds.rb
ApplicationRecord.transaction do
  # オフィス1件
  office = Office.find_or_create_by!(name: "本社")

  # チーム2件
  teams = []
  for name in ["Team A", "Team B"]
    teams << Team.find_or_create_by!(office: office, name: name)
  end

  # 各チームにクライアント10名ずつ（合計20名）
  clients = []
  for team in teams
    for i in 1..10
      name = "#{team.name}-#{i}"
      clients << Client.find_or_create_by!(office: office, team: team, name: name)
    end
  end

  # シフト24件（1日ごとに1件、クライアントは循環）
  base = Date.current.beginning_of_month
  for i in 0...20
    d = base + i
    c = clients[i % clients.length]

    Shift.find_or_create_by!(office: office, client: c, date: d) do |s|
      s.shift_type  = 0
      s.slots       = 1
      s.is_escort   = false
      s.work_status = 0
      s.start_time  = Time.zone.parse("#{d} 09:00")
      s.end_time    = Time.zone.parse("#{d} 17:00")
      s.note        = "シードデータ"
    end
  end
end
