require 'rails_helper'

RSpec.describe UsersSkill, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:skill) }
end
