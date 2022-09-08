require 'test_helper'

require 'scenarios/foreman/nightly'

describe Scenarios::Foreman::Nightly::Abstract do
  # Mimic rspec
  def described_class
    Scenarios::Foreman::Nightly::Abstract
  end

  describe '.target_version' do
    specify { assert_equal 'nightly', described_class.target_version }
  end

  describe '#target_version' do
    specify { assert_equal 'nightly', described_class.new.target_version }
  end
end
