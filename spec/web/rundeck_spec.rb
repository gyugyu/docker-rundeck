require "spec_helper"

describe port(4440) do
  it { should be_listening }
end
