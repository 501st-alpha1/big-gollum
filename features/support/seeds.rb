# Seed the database to prep for tests

Before do
  test = User.new
  test.email = "admin@example.com"
  test.password = "password"
  test.save
end