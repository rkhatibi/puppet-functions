#
# first.rb
#
# Copyright 2011 Puppet Labs Inc.
# Copyright 2011 Krzysztof Wilczynski
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
  newfunction(:first, :type => :rvalue, :doc => <<-EOS
Returns first element from an array given.

Prototype:

    first(a)

Where a is an array type.

For example:

  Given the following statements:

    $a = ["a", "b", "c"]
    $b = ["d", "e", "f"]

    notice first($a)
    notice first($b)

  The result will be as follows:

    notice: Scope(Class[main]): a
    notice: Scope(Class[main]): d
    EOS
  ) do |arguments|

    raise Puppet::ParseError, "first(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)" if arguments.size < 1

    array = arguments.shift

    raise Puppet::ParseError, 'first(): Requires an array ' +
      'to work with' unless array.is_a?(Array)

    array.first
  end
end

# vim: set ts=2 sw=2 et :
