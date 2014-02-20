# Users
User.destroy_all
User.create login: 'admin'

# Roles
Role.destroy_all

# Resources
Forum.create name: 'forum 1'
