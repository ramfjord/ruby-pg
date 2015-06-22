#!/usr/bin/env ruby
require 'json'

module PG
	module TextDecoder
		class Date < SimpleDecoder
			ISO_DATE = /\A(\d{4})-(\d\d)-(\d\d)\z/

			def decode(string, tuple=nil, field=nil)
				if string =~ ISO_DATE
					Time.new $1.to_i, $2.to_i, $3.to_i
				else
					string
				end
			end
		end

		class TimestampWithoutTimeZone < SimpleDecoder
			ISO_DATETIME_WITHOUT_TIMEZONE = /\A(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)(\.\d+)?\z/

			def decode(string, tuple=nil, field=nil)
				if string =~ ISO_DATETIME_WITHOUT_TIMEZONE
					Time.new $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, "#{$6}#{$7}".to_r
				else
					string
				end
			end
		end

		class TimestampWithTimeZone < SimpleDecoder
			ISO_DATETIME_WITH_TIMEZONE = /\A(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)(\.\d+)?([-\+]\d\d):?(\d\d)?:?(\d\d)?\z/

			def decode(string, tuple=nil, field=nil)
				if string =~ ISO_DATETIME_WITH_TIMEZONE
					Time.new $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, "#{$6}#{$7}".to_r, "#{$8}:#{$9 || '00'}:#{$10 || '00'}"
				else
					string
				end
			end
		end

		class Json < SimpleDecoder
			def decode(string, tuple=nil, field=nil)
				puts "looking at json: #{string}"
				JSON.parse string
			rescue JSON::ParserError
				string
			end
		end

		class Jsonb < SimpleDecoder
			def decode(string, tuple=nil, field=nil)
				puts "looking at jsonb: #{string}"
				JSON.parse string
			rescue JSON::ParserError
				string
			end
		end
	end
end # module PG

