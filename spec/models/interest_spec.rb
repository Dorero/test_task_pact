require 'rails_helper'

RSpec.describe Interest, type: :model do
  it { should have_many(:users).through(:users_interests) }
end
