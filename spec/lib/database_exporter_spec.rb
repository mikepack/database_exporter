require 'spec_helper'

describe DatabaseExporter do
  describe '#initialize' do
    it 'initializes the MysqlAdapter when passed a MySQL config' do
      MysqlAdapter.should_receive(:new).with({'adapter' => 'mysql2'})
      DatabaseExporter.new({'adapter' => 'mysql2'})
    end
  end

  describe '#export, #import, #copy' do
    it 'all exist (and are delegated to the adapter)' do
      exporter = DatabaseExporter.new({'adapter' => 'mysql2'})
      [:export, :import, :copy, :ensure_db_exists].each do |method|
        exporter.respond_to?(method).should be_true
      end
    end
  end
end