#!/usr/bin/env ruby
#
#    df_large, because in 2011, incredibly, some people have terminals with more than 80 columns and 8 colours!
#
#    Copyright (C) 2011 Thomas Kister <thomas.kister256@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# here we split the POSIX output of df, we're lucky the only column title with a space inside is at the last position
df = `df -P`.map { |l| l.chomp.split(" ",6) }

# replace each string by its size, then get the maximum length on each column
maxs = df.map { |l| l[0,5].map { |s| s.size } }.inject([0,0,0,0,0]) { |s,v| s.each_with_index.map { |m,i| [m,v[i]].max } }

# print the column titles with proper spacing and left alignment
(0..4).each { |i| printf("%-#{maxs[i]+1}s",df[0][i]) }
puts df[0][5]

# print the partition lines
df.drop(1).each do |l|
	printf("%-#{maxs[0]+1}s",l[0])
	(1..3).each { |j| printf("%#{maxs[j]}s ",l[j]) }

	# here we map the percentage to an index, colours from green to red: 46,76,106,136,166,196
	perc = l[4][/(\d+)%/,1].to_i
	cind = perc < 100 ? (perc * 6) / 100 : 5
	# we must output the special characters outside of the string, otherwise the blank filling algorithm gets confused
	printf("[38;5;#{46+cind*30}m%#{maxs[4]}s[0;m ",l[4])

	puts l[5]
end
