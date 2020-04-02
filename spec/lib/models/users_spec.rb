require 'spec_helper'

RSpec.describe User do
  it 'should create a User' do
    count_before = User.all.count
    user = User.new(document_id: 123456, name: "New user")
    user.save
    count_after = User.all.count
    expect(count_before).to be < count_after
    expect(user).to be_valid
    expect(user.document_id).to eq(123456)
    expect(user.name).to eq("New user")
  end
end
