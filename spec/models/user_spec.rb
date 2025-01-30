require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:interests).through(:users_interests) }
  it { should have_many(:skills).through(:users_skills) }
end
