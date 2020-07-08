#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'benchmark/ips'
require 'fileutils'

OLD_PREFIX = '@@HOMEBREW_PREFIX@@'
NEW_PREFIX = `brew --prefix`.strip

OUT = $stdout.clone
ERR = $stderr.clone
NULL = File.open File::NULL, 'w'

OPTS = {patch: false, require: true, times: 1}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: bm-pelf.rb [options] elf [elf ...]"

  # disable in favor of benchmark/ips
  #
  #   opts.on('-n TIMES', '--times=TIMES',
  #           "+ve INT. Number of TIMES to benchmark",
  #          Integer) do |v|
  #     if v < OPTS[:times]
  #       raise OptionParser::InvalidArgument, "#{v} . TIMES should be >= 1"
  #     end
  #     OPTS[:times] = v
  #   end

  opts.on("--no-require", "don't time \"require 'patchelf.rb'\"") do |v|
    require 'patchelf'
    OPTS[:require] = false
  end

  opts.on("--patch") do |v|
    OPTS[:patch] = v
  end
end
parser.parse!

elf_paths = ARGV.clone
if elf_paths.empty?
  puts parser
  exit 21
end

if elf_paths.count > 1 && OPTS[:require]
  puts "\e[;33mDISCLAIMER\e[;0m: passing multiple elfs without --no-require may not provide accurate results."
end

if OPTS[:times] > 1 && OPTS[:require]
  puts "\e[;33mDISCLAIMER\e[;0m: multiple benchmark results are more accurate with --no-require"
end



def turn_off_std
  return unless block_given?

  $stdout.reopen(NULL)
  $stderr.reopen(NULL)
  yield
  $stdout.reopen(OUT)
  $stderr.reopen(ERR)
end

def replace_interp_prefix(old_interpreter)
  if File.readable? "#{NEW_PREFIX}/lib/ld.so"
    "#{NEW_PREFIX}/lib/ld.so"
  else
    old_interpreter.sub OLD_PREFIX, NEW_PREFIX
  end
end

def replace_rpath_prefix(old_rpath)
  old_rpath.gsub(OLD_PREFIX, NEW_PREFIX)
end

def patch(elf_path)
  old_rpath = `patchelf --print-rpath --force-rpath "#{elf_path}"`.strip
  old_interpreter = `patchelf --print-interpreter "#{elf_path}"`.strip


  if OPTS[:patch]
    new_rpath = replace_rpath_prefix old_rpath
    new_interpreter = replace_interp_prefix old_interpreter

    turn_off_std do
      system "--set-interpreter", new_interpreter, "--force-rpath", "--set-rpath", new_rpath, elf_path
    end
  end
end

def patch_rb(elf_path)
  require 'patchelf' if OPTS[:require]

  patchelf = PatchELF::Patcher.new(elf_path, logging: false)
  patchelf.use_rpath!
  # we'll just empty string here as patchelf doesn't exit with failure for empty rpath.
  old_rpath = patchelf.runpath rescue ""
  old_interpreter = patchelf.interpreter

  if OPTS[:patch]
    new_rpath = replace_rpath_prefix(old_rpath)
    new_interpreter = replace_interp_prefix(old_interpreter)

    patchelf.runpath = new_rpath
    patchelf.interpreter = new_interpreter
    patchelf.save
  end
end

def generate_name elf_path, sfx
  elf_to_patch = ""
  0.step do |i|
    elf_to_patch = "/tmp/tt-tttt-#{i}-#{elf_path.gsub '/', ';;'} -- #{sfx}"
    break unless File.exist? elf_to_patch
  end
  elf_to_patch
end


elf_paths.each do |elf_path|
  # confirm file has interp and it is a valid ELF
  turn_off_std do
    system 'patchelf', '--print-interpreter', elf_path
  end
  next unless $?.success?

  # result_log = "/tmp/pelf-bm-#{elf_path.gsub '/', '___'}"
  # FileUtils.touch result_log

  puts "\n=>\e[;34m #{elf_path} \e[;0m"

  Benchmark.ips do |bm|
    %i[patch_rb patch].each do |fn|

      # generating name once should be enough, the steps are not threaded as
      # far as im aware
      elf_to_patch = generate_name elf_path, fn.to_s

      bm.report(fn.to_s) {
        # restore fresh file, to avoid cache issues
        FileUtils.copy_file elf_path, elf_to_patch
        FileUtils.chmod "u+w", elf_to_patch
        method(fn).call elf_to_patch
        FileUtils.rm elf_to_patch
      }
    end

    # bm.hold! result_log
    bm.compare!
  end
end
