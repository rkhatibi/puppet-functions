#
# range.rb
#
# Copyright 2012 Krzysztof Wilczynski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Puppet::Parser::Functions
  newfunction(:range, :type => :rvalue, :doc => <<-EOS
Returns a new array that contains a list of elements upon expanding values
between given start and stop interval, applying step factor accordingly.

Prototype:

    range(a, b)
    range(a, b, s)

Where both a and b are either a string or numeric values, and where s
is a non-negative integer value.

For example:

  Given the following statements:

    $a = 1
    $b = 10
    $c = 'a'
    $d = 'z'
    $e = 'abc1'
    $f = 'abc010'

    notice range($a, $b)
    notice range($a, $b, 2)
    notice range($c, $d)
    notice range($e, $f)

  The result will be as follows:

    notice: Scope(Class[main]): 1 2 3 4 5 6 7 8 9 10
    notice: Scope(Class[main]): 1 3 5 7 9
    notice: Scope(Class[main]): a b c d e f g h i j k l m n o p q r s t u v w x y z
    notice: Scope(Class[main]): abc001 abc002 abc003 abc004 abc005 abc006 abc007 abc008 abc009 abc010

  Known issues:

    Currently, using zero-padding and negative integer values for either
    start or stop parameters may result in undesirable outcome.
  EOS
  ) do |*arguments|
    #
    # This is to ensure that whenever we call this function from within
    # the Puppet manifest or alternatively form a template it will always
    # do the right thing ...
    #
    arguments = arguments.shift if arguments.first.is_a?(Array)

    # We support three arguments but at least two are mandatory ...
    raise Puppet::ParseError, "range(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)" if arguments.size < 2

    start = arguments.shift
    stop  = arguments.shift

    step = arguments.shift || 1

    [start, stop].each do |i|
      # This should cover all the generic numeric types present in Puppet ...
      unless i.class.ancestors.include?(Numeric) or i.is_a?(String)
        raise Puppet::ParseError, 'range(): Requires a numeric ' +
          'type to work with'
      end

      raise Puppet::ParseError, 'range(): An argument given cannot ' +
        'be an empty string value' if i.is_a?(String) and i.empty?
    end

    # Numbers in Puppet are often string-encoded which is troublesome ...
    if step.is_a?(Integer) or (step.is_a?(String) and step.match(/^-?\d+$/))
      # An Integer value should match ...
      step = step.to_i

      # Step cannot be of an negative size ...
      raise Puppet::ParseError, 'range(): Requires a non-negative ' +
        'integer value to work with' if step < 0
    else
      raise Puppet::ParseError, 'range(): Requires an integer ' +
        'value to work with'
    end

    # Puppet and its string-encoded numeric values. Sickening ...
    start = start.to_s if start.is_a?(Integer)
    stop  = stop.to_s  if stop.is_a?(Integer)

    range = []

    # We have a mixture of numeric values and characters, or just characters ...
    if start.match(/-?\d+/) and stop.match(/-?\d+/)
      pattern = start.clone

      start = start.match(/-?\d+/)[0]
      stop  = stop.match(/-?\d+/)[0]

      zero_padding = begin
        count = 0

        [start, stop].each do |i|
          value = i.match(/-?\d+/)[0]
          count = value.size if value.match(/^0+/) and value.size > count
        end

        count
      end

      start = start.to_i
      stop  = stop.to_i

      raise Puppet::ParseError, 'range(): An invalid start or stop ' +
        'value given' if start > stop

      range = (start .. stop).step(step).collect do |i|
        pattern.sub(/-?\d+/, sprintf("%0#{zero_padding}i", i))
      end
    elsif start.match(/\D+/) and stop.match(/\D+/)
      start = start.to_s
      stop  = stop.to_s

      range = (start .. stop).step(step).to_a
    else
      raise Puppet::ParseError, 'range(): An incompatible ' +
        'start or stop value given'
    end

    range
  end
end

# vim: set ts=2 sw=2 et :
# encoding: utf-8
