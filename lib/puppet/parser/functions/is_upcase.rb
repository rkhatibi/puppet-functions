#
# is_upcase.rb
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
  newfunction(:is_upcase, :type => :rvalue, :doc => <<-EOS
Returns true if given string value contains only upper-case letters and false otherwise.

Prototype:

    is_upcase(s)

Where s is a string value.

For example:

  Given the following statements:

    $a = 'ABC'
    $b = 'def'
    $c = 'Ghi'
    $d = 'jKl'

    notice is_upcase($a)
    notice is_upcase($b)
    notice is_upcase($c)
    notice is_upcase($d)

  The result will be as follows:

    notice: Scope(Class[main]): true
    notice: Scope(Class[main]): false
    notice: Scope(Class[main]): false
    notice: Scope(Class[main]): false
    EOS
  ) do |*arguments|
    #
    # This is to ensure that whenever we call this function from within
    # the Puppet manifest or alternatively form a template it will always
    # do the right thing ...
    #
    arguments = arguments.shift if arguments.first.is_a?(Array)

    string = arguments.shift

    raise Puppet::ParseError, 'is_upcase(): Requires a string type ' +
      'to work with' unless string.is_a?(String)

    string == string.upcase
  end
end

# vim: set ts=2 sw=2 et :
# encoding: utf-8
