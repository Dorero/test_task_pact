require 'rails_helper'

RSpec.describe Skill, type: :model do
  it { should have_many(:users).through(:users_skills) }
end
