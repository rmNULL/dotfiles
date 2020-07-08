#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'
require 'fileutils'
exit 21 if ARGV.count < 1


OLD_PREFIX = '@@HOMEBREW_PREFIX@@'
NEW_PREFIX = `brew --prefix`.strip

OUT = $stdout.clone
ERR = $stderr.clone
NULL = File.open File::NULL, 'w'

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

  new_rpath = replace_rpath_prefix old_rpath
  new_interpreter = replace_interp_prefix old_interpreter

  turn_off_std do
    system "--set-interpreter", new_interpreter, "--force-rpath", "--set-rpath", new_rpath, elf_path
  end
  # `patchelf --set-interpreter "#{new_interpreter}" --force-rpath --set-rpath "#{new_rpath}" "#{elf_path}"`
end

def patch_rb(elf_path)
  require 'patchelf'

  patchelf = PatchELF::Patcher.new(elf_path, logging: false)
  patchelf.use_rpath!
  # we'll just empty string here as patchelf doesn't exit with failure for empty rpath.
  old_rpath = patchelf.runpath rescue ""

  new_rpath = replace_rpath_prefix(old_rpath)
  new_interpreter = replace_interp_prefix(patchelf.interpreter)

  patchelf.runpath = new_rpath
  patchelf.interpreter = new_interpreter
  patchelf.save
end

elf_paths = ARGV.clone


elf_paths.each do |elf_path|

  # confirm file has interp and it is a valid ELF
  turn_off_std do 
    system 'patchelf', '--print-interpreter', elf_path
  end
  next unless $?.success?

  elf_to_patch = "/tmp/tt-tttt-tt-#{File.basename elf_path}"

  puts "\n=>\e[;34m #{elf_path} \e[;0m"

  Benchmark.bm(8) do |bm|
    %i[patch patch_rb].each do |fn|
      # restore fresh file, to avoid cache issues
      FileUtils.copy_file elf_path, elf_to_patch
      FileUtils.chmod "u+w", elf_to_patch
      bm.report(fn.to_s) { method(fn).call elf_to_patch }
      FileUtils.rm elf_to_patch
    end
  end
end
