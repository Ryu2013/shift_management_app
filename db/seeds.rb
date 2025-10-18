require "logger"
ActiveRecord::Base.logger = Logger.new($stdout) # SQLを標準出力へ
Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new($stdout))

puts "🌱 Seeding start (ENV=#{Rails.env})"


# db/seeds.rb
ApplicationRecord.transaction do
  # オフィス1件
  office = Office.find_or_create_by!(name: "本社")

  # チーム2件
  teams = []
  for name in ["Team A", "Team B"]
    teams << Team.find_or_create_by!(office: office, name: name)
  end

login_user = User.find_or_initialize_by(email: "honsya@example.com")
login_user.name           ||= "本社ログイン用"
login_user.office         ||= office           # ← NOT NULL 対策
login_user.account_status ||= 0
login_user.password = "password"              # ← 毎回セットでOK（暗号化される）
login_user.save!
puts "👤 Login user: #{login_user.email} / password"

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
  for i in 0...100
    d = base + i
    c = clients[i % clients.length]

    Shift.find_or_create_by!(office: office, client: c, date: d) do |s|
      s.shift_type  = [0, 1].sample  
      s.slots       = 1
      s.is_escort   = false
      s.work_status = 0
      s.start_time  = "09:00"
      s.end_time    = "17:00"
      s.note        = "シードデータ"
    end
  end
end
puts "✅ Seeding done."
puts "Counts: #{{
  offices: Office.count, teams: Team.count, clients: Client.count,
  shifts: Shift.count, users: User.count
}}"