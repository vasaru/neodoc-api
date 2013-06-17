# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Configuration.create(:category => 'Devices', :name => 'Manage Device Types', :value => 'managedevicetypes')
Configuration.create(:category => 'Devices', :name => 'Manage Operating Systems', :value => 'manageoperatingsystems')
Configuration.create(:category => 'Main', :name => 'SMTP Configuration', :value => 'smtpconfig')
Configuration.create(:category => 'Main', :name => 'Backup/Restore', :value => 'backuprestoreconfig')
