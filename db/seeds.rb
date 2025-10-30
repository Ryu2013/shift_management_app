require "logger"
ActiveRecord::Base.logger = Logger.new($stdout) # SQLを標準出力へ
Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new($stdout))

puts "🌱 Seeding start (ENV=#{Rails.env})"

# スキーマに合わせて、存在チェックしながら安全に作成
ApplicationRecord.transaction do
  # Office（ユニーク: name）
  office = Office.find_or_create_by!(name: "本社")

  # Teams（少なくともログインユーザー用のメインチームを用意）
  main_team = Team.find_or_create_by!(office: office, name: "本社チーム")
  # 追加のサンプルチーム
  ["Team A", "Team B"].each do |name|
    Team.find_or_create_by!(office: office, name: name)
  end

  # ログイン可能ユーザー（Devise: confirmable 対応のため confirmed_at を付与）
  login_user = User.find_or_initialize_by(email: "honsya@example.com")
  login_user.name           ||= "本社ログイン用"
  login_user.office         ||= office
  login_user.team           ||= main_team
  login_user.account_status ||= 0 # active
  login_user.password = "password" # 都度セットでOK
  login_user.confirmed_at ||= Time.current
  login_user.save!

  puts "👤 Login user: #{login_user.email} / password"

  # 追加の従業員10名（本社チーム配属・即ログイン可能）
  employees = []
  10.times do |i|
    email = "employee#{i + 1}@example.com"
    u = User.find_or_initialize_by(email: email)
    u.name           ||= "従業員#{i + 1}"
    u.office         ||= office
    u.team           ||= main_team
    u.account_status ||= 0
    u.password = "password"
    u.confirmed_at ||= Time.current
    u.save!
    employees << u
  end
  puts "👥 Employees: #{employees.map(&:email).join(', ')} / password"

  # クライアントをメインチームに作成
  clients = []
  10.times do |i|
    name = "#{main_team.name}-#{i + 1}"
    clients << Client.find_or_create_by!(office: office, team: main_team, name: name)
  end

  # user_clients（ユニークインデックス対応）: ログインユーザーを先頭クライアントに紐付け
  first_client = clients.first
  if first_client
    UserClient.find_or_create_by!(office: office, client: first_client, user: login_user)
  end

  # シフト（当月〜100日分）: user は未設定でも可（schemaではNULL可）
  base = Date.current.beginning_of_month
  100.times do |i|
    d = base + i.days
    c = clients[i % clients.length]
    Shift.find_or_create_by!(office: office, client: c, date: d) do |s|
      s.shift_type  = [0, 1].sample
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
  shifts: Shift.count, users: User.count, user_clients: UserClient.count
}}"
