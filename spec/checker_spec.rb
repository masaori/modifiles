# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe Modifiles::Checker do
  before do
    @root_path = File.dirname(File.expand_path("#{__FILE__}/../"))
    @stamp_file_path = File.join(File.dirname(__FILE__), 'test_sha1.txt');
    @base_sha1 = 'c47ff4646902feb0a1ebd14309c7919dc5246ca6'

    File.open(@stamp_file_path, "w") { |io| io.write @base_sha1 }

    Modifiles::Checker.stamp_file_path = @stamp_file_path

    @added    = `git diff --name-only --diff-filter=A #{@base_sha1} HEAD`.split("\n").map {|e| File.join(GIT_ROOT, e)}
    @deleted  = `git diff --name-only --diff-filter=D #{@base_sha1} HEAD`.split("\n").map {|e| File.join(GIT_ROOT, e)}
    @modified = `git diff --name-only --diff-filter=M #{@base_sha1} HEAD`.split("\n").map {|e| File.join(GIT_ROOT, e)}
  end

  describe '#stamp' do
    it 'records latest commit SHA1' do
      Modifiles::Checker.stamp
      Modifiles::Checker.last_stamp.should eql `git log -1 --pretty=format:%H`
    end 
  end

  describe '#last_stamp' do
    it 'returns the latest recorded commit SHA1' do
      Modifiles::Checker.last_stamp.should eql @base_sha1
    end

    context 'when stamp file does not exist' do
      before do
        File.delete(@stamp_file_path) if File.exists?(@stamp_file_path)
      end

      it 'returns SHA1 of the first commit' do
        Modifiles::Checker.last_stamp.should eql `git log --pretty=format:%H | tail -1`
      end
    end
  end

  describe '#added_files' do
    it 'returns new added files(absolute path) since latest stamp.' do
      Modifiles::Checker.added_files.each {|e| @added.should include e}
      Modifiles::Checker.added_files.length.should eql @added.length
    end
  end

  describe '#modified_files' do
    it 'returns new modified files(absolute path) since latest stamp.' do
      Modifiles::Checker.modified_files.each {|e| @modified.should include e}
      Modifiles::Checker.modified_files.length.should eql @modified.length
    end
  end

  describe '#deleted_files' do
    it 'returns new deleted files(absolute path) since latest stamp.' do
      Modifiles::Checker.deleted_files.each {|e| @deleted.should include e}
      Modifiles::Checker.deleted_files.length.should eql @deleted.length
    end
  end 

  describe '#added?' do
    it 'checks if the given file has been added after last_stamp commit' do
      @added.each {|e| Modifiles::Checker.added?(e).should be_true }
    end
  end

  describe '#modified?' do
    it 'checks if the given file has been modified after last_stamp commit' do
      @modified.each {|e| Modifiles::Checker.modified?(e).should be_true }
    end
  end

  describe '#deleted?' do
    it 'checks if the given file has been deleted after last_stamp commit' do
      @deleted.each {|e| Modifiles::Checker.deleted?(e).should be_true }
    end
  end

end